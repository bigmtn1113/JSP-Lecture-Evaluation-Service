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
	
	if (request.getParameter("id") != null)
		id = request.getParameter("id");
	if (request.getParameter("pw") != null)
		pw = request.getParameter("pw");
	
	if (id == null || pw == null || id.equals("") || pw.equals("")) {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('입력되지 않은 항목이 있습니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	}
	
	UserDao userDao = new UserDao();
	int result = userDao.login(id, pw);
	
	if (result == 1) {
		session.setAttribute("id", id);
		
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("location.href='index.jsp'");
		writer.println("</script>");
		writer.close();
		return;
	} else if (result == 0){
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('비밀번호가 일치하지 않습니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	} else if (result == -1){
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('존재하지 않는 아이디입니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	} else if (result == -2){
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('데이터베이스 오류가 발생했습니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	}
%>