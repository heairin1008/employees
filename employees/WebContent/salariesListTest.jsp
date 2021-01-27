<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	
	
	Class.forName("");
	Connection conn = DriverManager.getConnection("", "", "");
	String sql = "select max(salary) from salaries";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	int beginSalary = 0;
	int endSalary = 0;
	int maxSalary = 0;
	if(rs.next()){
		maxSalary = rs.getInt("max(salary)"); //max(salary) = 158,220
		endSalary = maxSalary; // endSalary가 null일 경우 maxSalary 값 대입
	}
	if(request.getParameter("beginSalary") != null){
		beginSalary = Integer.parseInt(request.getParameter("beginSalary"));
	}
	if(request.getParameter("endSalary") != null){ //endSalary가 null이 아닐 경우
		endSalary = Integer.parseInt(request.getParameter("endSalary"));
	}
	
	String sql2 = "select * from salaries where salary between ? and ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, beginSalary);
	stmt2.setInt(2, endSalary);
	ResultSet rs2 = stmt2.executeQuery();
%>
	<h1>salaries 목록</h1>
	<table border="1">
		<tr>
			<th>emp_no</th>
			<th>salary</th>
			<th>from_date</th>
			<th>to_date</th>
		</tr>
		<%
			while(rs2.next()){
		%>
				<tr>
					<td><%=rs2.getInt("emp_no")%></td>
					<td><%=rs2.getInt("salary")%></td>
					<td><%=rs2.getString("from_date")%></td>
					<td><%=rs2.getString("to_date")%></td>
				</tr>
		<%
			}
		%>
	</table>
	<form method="post" action="./salariesListTest.jsp">
		<select name="beginSalary">
			<%
				for(int i=0; i<maxSalary; i=i+10000){
			%>
					<option value="<%=i%>" selected="selected"><%=i%></option>
			<%
				}
			%>
		</select>
		<select name="endSalary">
			<%
				for(int i=maxSalary; i>0; i=i-10000){
			%>
					<option value="<%=i%>" selected="selected"><%=i%></option>
			<%
				}
			%>
		</select>
		<button type="submit">검색</button>
	</form>
	
	
	
	
</body>
</html>