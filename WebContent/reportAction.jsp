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
	
	String reportTitle = null;
	String reportContent = null;
	
	if (request.getParameter("reportTitle") != null)
		reportTitle = request.getParameter("reportTitle");
	if (request.getParameter("reportContent") != null)
		reportContent = request.getParameter("reportContent");
	
	if (reportTitle == null || reportContent == null) {
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('입력하지 않은 항목이 있습니다.');");
		writer.println("history.back();");
		writer.println("</script>");
		writer.close();
		return;
	}
	
	String host = "http://localhost:8181/Lecture_Evaluation_Service/";
	String from = "구글 이메일";
	String to = "kva231@naver.com";
	String subject = "강의평가 사이트에서 접수된 신고 메일입니다.";
	String content = "신고자: " + id + "<br>제목: " + reportTitle + "<br>내용: " + reportContent;
	
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
	
	PrintWriter writer = response.getWriter();
	writer.println("<script>");
	writer.println("alert('정상적으로 신고되었습니다.');");
	writer.println("history.back();");
	writer.println("</script>");
	writer.close();
	return;
	
%>