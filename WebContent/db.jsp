<%@ page import="java.sql.*"%>
<%
String xDb_Conn_Str = getServletContext().getInitParameter("conn")+ "?useUnicode=" + getServletContext().getInitParameter("useUnicode") + "&characterEncoding=" + getServletContext().getInitParameter("characterEncoding") + "&characterSetResults=" + getServletContext().getInitParameter("characterSetResults");
String user = getServletContext().getInitParameter("user");
String pass = getServletContext().getInitParameter("pass");
//System.out.println("DB"+xDb_Conn_Str);
Connection conn = (Connection) session.getAttribute("connnection");
try{
	
	if(conn == null){ 
		conn = DriverManager.getConnection(xDb_Conn_Str,user,pass);
	}
	else {
	if(conn.isClosed()) 
		System.out.println("Opening....." + xDb_Conn_Str);
		
		conn = DriverManager.getConnection(xDb_Conn_Str,user,pass);
	}
	session.setAttribute("connnection",conn);
}catch (SQLException ex){
	out.println(ex.toString());
}
%>

