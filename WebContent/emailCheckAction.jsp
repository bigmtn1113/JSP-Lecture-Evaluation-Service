<%@page import="util.Sha256"%>
<%@page import="user.UserDao"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String id = null;
	String code = null;
	
	if (session.getAttribute("id") != null)
		id = (String) session.getAttribute("id");
	
	if (request.getParameter("code") != null)
		code = request.getParameter("code");
	
	if (id == null) {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('로그인을 해주세요.');");
		writer.println("location.href='userLogin.jsp'");
		writer.println("</script>");
		writer.close();
		return;
	}
	
	UserDao userDao = new UserDao();
	String email = userDao.getEmail(id);
	boolean isRight = (new Sha256().getSha256(email).equals(code)) ? true : false;
	
	if (isRight == true) {
		userDao.setEmailChecked(id);
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('인증에 성공했습니다.');");
		writer.println("location.href='index.jsp'");
		writer.println("</script>");
		writer.close();
		return;
	} else {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('유효하지 않은 코드입니다.');");
		writer.println("location.href='userLogin.jsp'");
		writer.println("</script>");
		writer.close();
		return;
	}
%>