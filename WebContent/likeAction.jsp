<%@page import="likey.LikeyDao"%>
<%@page import="evaluation.EvaluationDao"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%!
	public static String getClientIp(HttpServletRequest request) {
		String ip = request.getHeader("X-FORWARDED-FOR");
		
		if (ip == null || ip.length() == 0) ip = request.getHeader("Proxy-Client-IP");
		if (ip == null || ip.length() == 0) ip = request.getHeader("WL-Proxy-Client-IP");
		if (ip == null || ip.length() == 0) ip = request.getRemoteAddr();
		
		return ip;
	}
%>
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
	LikeyDao likeyDao = new LikeyDao();
	
	int result = likeyDao.like(id, eId, getClientIp(request));
	
	if (result == 1) {
		result = evaluationDao.like(eId);
		
		if (result == 1) {
			PrintWriter writer = response.getWriter();
			writer.println("<script>");
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
		writer.println("alert('이미 추천을 누른 글입니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	}
	
%>