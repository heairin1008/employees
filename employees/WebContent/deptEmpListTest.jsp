<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deptEmpListTest</title>
</head>
<body>
	<!-- 메뉴 -->
	<nav class="navbar navbar-expand-sm bg-light navbar-light">
		<ul class="navbar-nav">
			<li class="nav-item active">
	      		<a style="font-size:18px;" class="nav-link" href="./">Employees</a>
	    	</li>
		    <li class="nav-item">
		      	<a class="nav-link" href="./departmentsList.jsp">DEPARTMENTS 목록</a>
		    </li>
		    <li class="nav-item">
		      	<a class="nav-link disabled" href="./deptEmpList.jsp">DEPT_EMP 목록</a>
		    </li>
		    <li class="nav-item">
		      	<a class="nav-link" href="./deptManagerList.jsp">DEPT_MANAGER 목록</a>
		    </li>
		    <li class="nav-item">
		      	<a class="nav-link" href="./employeesList.jsp">EMPLOYEES 목록</a>
		    </li>
		    <li class="nav-item">
		      	<a class="nav-link" href="./salariesList.jsp">SALARIES 목록</a>
		    </li>
		    <li class="nav-item">
		      	<a class="nav-link" href="./titlesList.jsp">TITLES 목록</a>
		    </li>
	  	</ul>
	</nav>
	<h1>dept_emp 목록</h1>
	<%
		int currentPage = 1; // currentPage의 매개변수가 넘어오지 않으면 1
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
			// currentPage의 매개변수가 넘어오면 변수에 입력
		}
		String ck = "no";
		if(request.getParameter("ck") != null){
			ck = request.getParameter("ck"); // ck = "yes";
		}
		
		String deptNo = "";
		if(request.getParameter("deptNo") != null){
			deptNo = request.getParameter("deptNo");
		}
		int rowPerPage = 10;
		int beginRow = (currentPage - 1) * rowPerPage;
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://unuho.kro.kr/employees", "goodee", "java1004");
		String sql = "";
		PreparedStatement stmt = null;
		if(ck.equals("no") && deptNo.equals("")){
			sql = "select * from dept_emp limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
		}else if(ck.equals("no") && (!deptNo.equals(""))){
			sql = "select * from dept_emp where deptNo = ? limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, deptNo);
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
		}else if(ck.equals("yes") && deptNo.equals("")){
			sql = "select * from dept_emp where to_date = '9999-01-01' limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
		}else{
			sql = "select * from dept_emp where to_date = '9999-01-01' and deptNo = ? limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, deptNo);
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
		}

		ResultSet rs = stmt.executeQuery();
		
		String sql2 = "select dept_no from departments";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		ResultSet rs2 = stmt2.executeQuery();
	%>
	
	<form action="./deptEmpListTest.jsp">
	<%
		if(ck.equals("no")){
	%>
		<input type="checkbox" name="ck" value="yes">현재 부서에 근무중
	<%
		}else{
	%>
		<input type="checkbox" name="ck" value="yes" checked = "checked">현재 부서에 근무중
	<%
		}
	%>
		
		<select name="deptNo">
			<option value="">선택안함</option>
			<%
				while(rs2.next()){
					if(deptNo.equals(rs2.getString("dept_no"))){
			%>
						<option value="<%=rs2.getString("dept_no")%>" selected="selected"><%=rs2.getString("dept_no")%></option>
			<%
					}else{
			%>
					<option value="<%=rs2.getString("dept_no")%>"><%=rs2.getString("dept_no")%></option>
			<%
					}
				}
			%>
		</select>
		<button type="submit">검색</button>
	</form>
	
	<table border="1">
		<tr>
			<th>emp_no</th>
			<th>dept_no</th>
			<th>from_date</th>
			<th>to_date</th>
		</tr>
		<% 
			while(rs.next()){
		%>
				<tr>
					<td><%=rs.getInt("emp_no")%></td>
					<td><%=rs.getString("dept_no")%></td>
					<td><%=rs.getString("from_date")%></td>
					<td><%=rs.getString("to_date")%></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>