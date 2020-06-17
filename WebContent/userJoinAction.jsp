<%@page import="util.Sha256"%>
<%@page import="user.UserDto"%>
<%@page import="user.UserDao"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String id = null;
	String pw = null;
	String email = null;
	
	if (request.getParameter("id") != null)
		id = request.getParameter("id");
	if (request.getParameter("pw") != null)
		pw = request.getParameter("pw");
	if (request.getParameter("email") != null)
		email = request.getParameter("email");
	
	if (id == null || pw == null || email == null ||
			id.equals("") || pw.equals("") || email.equals("")) {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('입력되지 않은 항목이 있습니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	}
	
	UserDao userDao = new UserDao();
	int result = userDao.join(new UserDto(id, pw, email, Sha256.getSha256(email), '0'));
	
	if (result == -1) {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('이미 존재하는 아이디입니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	} else {
		session.setAttribute("id", id);
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("location.href='emailSendAction.jsp'");
		writer.println("</script>");
		writer.close();
		return;
	}
%>