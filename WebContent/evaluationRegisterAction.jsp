<%@page import="evaluation.EvaluationDto"%>
<%@page import="evaluation.EvaluationDao"%>
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

	String eLectureName = null;
	String eProfessorName = null;
	int eLectureYear = 0;
	String eSemesterDivide = null;
	String eLectureDivide = null;
	String eTitle = null;
	String eContent = null;
	String eTotalScore = null;
	String eCreditScore = null;
	String eComfortableScore = null;
	String eLectureScore = null;
	
	if (request.getParameter("eLectureName") != null) eLectureName = request.getParameter("eLectureName");
	if (request.getParameter("eProfessorName") != null) eProfessorName = request.getParameter("eProfessorName");
	if (request.getParameter("eLectureYear") != null) eLectureYear = Integer.parseInt(request.getParameter("eLectureYear"));
	if (request.getParameter("eSemesterDivide") != null) eSemesterDivide = request.getParameter("eSemesterDivide");
	if (request.getParameter("eLectureDivide") != null) eLectureDivide = request.getParameter("eLectureDivide");
	if (request.getParameter("eTitle") != null) eTitle = request.getParameter("eTitle");
	if (request.getParameter("eContent") != null) eContent = request.getParameter("eContent");
	if (request.getParameter("eTotalScore") != null) eTotalScore = request.getParameter("eTotalScore");
	if (request.getParameter("eCreditScore") != null) eCreditScore = request.getParameter("eCreditScore");
	if (request.getParameter("eComfortableScore") != null) eComfortableScore = request.getParameter("eComfortableScore");
	if (request.getParameter("eLectureScore") != null) eLectureScore = request.getParameter("eLectureScore");
	
	if (eLectureName == null || eProfessorName == null || eLectureYear == 0 ||
		eSemesterDivide == null || eLectureDivide == null || eTitle == null ||
		eContent == null || eTotalScore == null || eCreditScore == null ||
		eComfortableScore == null || eLectureScore == null ||
		eTitle.equals("") || eContent.equals("")) {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('입력되지 않은 항목이 있습니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	}
	
	EvaluationDao evaluationDao = new EvaluationDao();
	int result = evaluationDao.write(new EvaluationDto(0, id, eLectureName, eProfessorName, eLectureYear,
			eSemesterDivide, eLectureDivide, eTitle, eContent, eTotalScore, eCreditScore, eComfortableScore, eLectureScore, 0));
	
	if (result == -1) {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('강의 평가 등록에 실패했습니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	} else {
		session.setAttribute("id", id);
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("location.href='index.jsp'");
		writer.println("</script>");
		writer.close();
		return;
	}
%>