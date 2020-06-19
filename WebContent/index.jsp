<%@page import="java.net.URLEncoder"%>
<%@page import="evaluation.EvaluationDao"%>
<%@page import="evaluation.EvaluationDto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="user.UserDao"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!--
	반응형 웹에 사용.
	initial-scale: 페이지 처음 로드 시 초기 줌 레벨 설정
	shrink-to-fit=no: 애플의 사파리 브라우저(11이전 버전)에 영향. 내용이 viewport보다 크면 내용을 줄여서 보여주는데 그것을 방지. 
-->
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>강의평가 웹 사이트</title>
<link rel="stylesheet" href="./css/bootstrap.min.css">
<link rel="stylesheet" href="./css/custom.css">
</head>
<body>

	<%
		request.setCharacterEncoding("UTF-8");
	
		String id = null;
	
		if (session.getAttribute("id") != null)
			id = (String) session.getAttribute("id");
		
		if (id == null) {
			PrintWriter writer = response.getWriter();
			writer.println("<script>");
			writer.println("alert('로그인을 해주세요.');");
			writer.println("location.href='userLogin.jsp';");
			writer.println("</script>");
			writer.close();
			return;
		}
		
		UserDao userDao = new UserDao();
		char emailChecked = userDao.getEmailChecked(id).charAt(0);
		
		if (emailChecked == '0') {
			PrintWriter writer = response.getWriter();
			writer.println("<script>");
			writer.println("location.href='emailSendConfirm.jsp';");
			writer.println("</script>");
			writer.close();
			return;
		}
		
		String eLectureDivide = "전체";
		String searchType = "최신순";
		String search = "";
		int pageNumber = 0;
		
		if (request.getParameter("eLectureDivide") != null) eLectureDivide = request.getParameter("eLectureDivide");
		if (request.getParameter("searchType") != null) searchType = request.getParameter("searchType");
		if (request.getParameter("search") != null) search = request.getParameter("search");
		if (request.getParameter("pageNumber") != null) pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
			
	%>

	<script src="./js/jquery.min.js"></script>
	<script src="./js/popper.js"></script>
	<script src="./js/bootstrap.min.js"></script>	<!-- 이 순서대로 라이브러리 불러와야함. bootstrap먼저 불러오면 안됨. -->
	
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
		<!--
			data-toggle="collapse": 정보를 접었다가 클릭하면 펼쳐짐
			data-target="#abc": id="abc"와 연결. id는 접으려고 하는 컨텐츠
		-->
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown" href="#">회원관리</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
					<%
						if (id == null) {
					%>
						<a class="dropdown-item" href="userLogin.jsp">로그인</a>
						<a class="dropdown-item" href="userJoin.jsp">회원가입</a>
					<%
						} else {
					%>
						<a class="dropdown-item" href="userLogoutAction.jsp">로그아웃</a>
					<%
						}
					%>
					</div>
				</li>
			</ul>
			<form action="index.jsp" class="form-inline my-2 my-lg-0">
				<input class="form-control mr-sm-2" type="text" name="search" placeholder="내용을 입력하세요." aria-label="Search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	
	<section class="container">
		<form action="index.jsp" method="get" class="form-inline mt-3">
			<select name="eLectureDivide" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="전공" <% if(eLectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
				<option value="교양" <% if(eLectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
				<option value="기타" <% if(eLectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순" <% if(eLectureDivide.equals("최신순")) out.println("selected"); %>>최신순</option>
				<option value="추천순" <% if(eLectureDivide.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록</a>
			<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a>
		</form>
		
		<%
			ArrayList<EvaluationDto> evaluationList = new ArrayList<EvaluationDto>();
			evaluationList = new EvaluationDao().getList(eLectureDivide, searchType, search, pageNumber);
			
			if (evaluationList != null) {
				for (int i = 0; i < evaluationList.size(); ++i) {
					if (i == 5)
						break;
					EvaluationDto evaluation = evaluationList.get(i);
		%>
		
					<div class="card bg-light mt-3">
						<div class="card-header bg-light">
							<div class="row">
								<div class="col-8 text-left">
									<%= evaluation.geteLectureName() %>&nbsp;<small><%= evaluation.geteProfessorName() %></small>
								</div>
								<div class="col-4 text-right">
									종합 <span style="color: red;"><%= evaluation.geteTotalScore() %></span>
								</div>
							</div>
						</div>
						<div class="card-body">
							<h5 class="card-title">
								<%= evaluation.geteTitle() %>&nbsp;<small>(<%= evaluation.geteLectureYear() %>년 <%= evaluation.geteSemesterDivide() %>)</small>
							</h5>
							<p class="card-text"><%= evaluation.geteContent() %></p>
							<div class="row">
								<div class="col-9 text-left">
									성적 <span style="color: red;"><%= evaluation.geteCreditScore() %></span>
									널널 <span style="color: red;"><%= evaluation.geteComfortableScore() %></span>
									강의 <span style="color: red;"><%= evaluation.geteLectureScore() %></span>
									<span style="color: green;">(추천: <%= evaluation.geteLikeCount() %>)</span>
								</div>
								<div class="col-3 text-right">
									<a onclick="return confirm('추천하시겠습니까?')" href="likeAction.jsp?evaluationId=">추천</a>
									<a onclick="return confirm('삭제하시겠습니까?')" href="deleteAction.jsp?evaluationId=">삭제</a>
								</div>
							</div>
						</div>
					</div>
		<%
				}
			}
		%>
	</section>
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
			<%
				if (pageNumber <= 0) {
			%>
				<a class="page-link disabled">이전</a>
			<%
				} else {
			%>
				<a class="page-link" href="index.jsp?eLectureDivide=<%= URLEncoder.encode(eLectureDivide, "UTF-8") %>
				&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>
				&pageNumber=<%= pageNumber - 1 %>">이전</a>
			<%
				}
			%>
		</li>
		<li>
			<%
				if (evaluationList.size() < 6) {
			%>
				<a class="page-link disabled">다음</a>
			<%
				} else {
			%>
				<a class="page-link" href="index.jsp?eLectureDivide=<%= URLEncoder.encode(eLectureDivide, "UTF-8") %>
				&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>
				&pageNumber=<%= pageNumber + 1 %>">다음</a>
			<%
				}
			%>
		</li>
	</ul>
	<div id="registerModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">평가 등록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="evaluationRegisterAction.jsp" method="post">
						<div class="form-row">
							<div class="form-group col-sm-6">
								<label>강의명</label>
								<input type="text" name="eLectureName" class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-6">
								<label>교수명</label>
								<input type="text" name="eProfessorName" class="form-control" maxlength="20">
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label>수강 연도</label>
								<select name="eLectureYear" class="form-control">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019">2019</option>
									<option value="2020" selected>2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023">2023</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>수강 학기</label>
								<select name="eSemesterDivide" class="form-control">
									<option value="1학기">1학기</option>
									<option value="여름학기">여름학기</option>
									<option value="2학기">2학기</option>
									<option value="겨울학기">겨울학기</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>강의 구분</label>
								<select name="eLectureDivide" class="form-control">
									<option value="전공">전공</option>
									<option value="교양">교양</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="eTitle" class="form-control" maxlength="30"> 
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="eContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea> 
						</div>
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label>종합</label>
								<select name="eTotalScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>	
							</div>
							<div class="form-group col-sm-3">
								<label>성적</label>
								<select name="eCreditScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>	
							</div>
							<div class="form-group col-sm-3">
								<label>널널</label>
								<select name="eComfortableScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>	
							</div>
							<div class="form-group col-sm-3">
								<label>강의</label>
								<select name="eLectureScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>	
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<div id="reportModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="reportAction.jsp" method="post">
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="reportTitle" class="form-control" maxlength="30"> 
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea> 
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger">신고</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #ffffff;">
		Copyright &copy; 2020 홍길동 All Rights Reserved.
	</footer>

</body>
</html>