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
	
	String eId = null;
	
	if (request.getParameter("eId") != null)
		eId = request.getParameter("eId");
	
	EvaluationDao evaluationDao = new EvaluationDao(); 
	
	if (id.equals(evaluationDao.getUserId(eId))) {
		
		int result = evaluationDao.delete(eId);
		
		if (result == 1) {
			PrintWriter writer = response.getWriter();
			writer.println("<script>");
			writer.println("alert('삭제되었습니다.');");
			writer.println("location.href = 'index.jsp'");
			writer.println("</script>");
			writer.close();
			return;
		} else {
			PrintWriter writer = response.getWriter();
			writer.println("<script>");
			writer.println("alert('데이터베이스 오류가 발생했습니다.');");
			writer.println("history.back();");
			writer.println("</script>");
			writer.close();
			return;
		}
		
	} else {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('자신이 작성한 글만 삭제 가능합니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	}
	
%>