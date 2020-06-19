<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.*"%>
<%@page import="java.util.Properties"%>
<%@page import="util.Gmail"%>
<%@page import="util.Sha256"%>
<%@page import="user.UserDto"%>
<%@page import="user.UserDao"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	String emailChecked = userDao.getEmailChecked(id);
	
	if (emailChecked.equals("1")) {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('이미 인증된 회원입니다.');");
		writer.println("location.href='index.jsp';");
		writer.println("</script>");
		writer.close();
		return;
	}
	
	String host = "http://localhost:8181/Lecture_Evaluation_Service/";
	String from = "구글 이메일";
	String to = userDao.getEmail(id);
	String subject = "강의평가를 위한 이메일 인증 메일입니다.";
	String content = "다음 링크에 접속하여 이메일 인증을 진행하세요. " +
		"<a href='" + host + "emailCheckAction.jsp?code=" + new Sha256().getSha256(to) + "'>이메일 인증하기</a>";
	
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	try {
		Authenticator auth = new Gmail();
		
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		
		Address fromAddr = new InternetAddress(from);
		msg.setFrom(fromAddr);
		
		Address toAddr = new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html;charset=UTF-8");
		
		Transport.send(msg);
	} catch (Exception e) {
		e.printStackTrace();
		
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('오류가 발생했습니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	}
	
%>

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
				<li class="nav-item">
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
			<form class="form-inline my-2 my-lg-0">
				<input class="form-control mr-sm-2" type="text" name="search" placeholder="내용을 입력하세요." aria-label="Search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-success mt-4" role="alert">
			이메일 주소 인증 메일이 전송되었습니다.
		</div>
	</section>
	
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #ffffff;">
		Copyright &copy; 2020 홍길동 All Rights Reserved.
	</footer>

</body>
</html>