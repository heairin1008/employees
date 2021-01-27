<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<!-- 메뉴  -->
	<nav class="navbar navbar-expand-sm bg-light navbar-light">
		<ul class="navbar-nav">
			<li class="nav-item active">
	      		<a style="font-size:18px;" class="nav-link" href="./">Employees</a>
	    	</li>
		    <li class="nav-item">
		      	<a class="nav-link " href="./departmentsList.jsp">DEPARTMENTS 목록</a>
		    </li>
		    <li class="nav-item">
		      	<a class="nav-link" href="./deptEmpList.jsp">DEPT_EMP 목록</a>
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
		      	<a class="nav-link disabled" href="./titlesList.jsp">TITLES 목록</a>
		    </li>
	  	</ul>
	</nav>
	
	<!-- titles 테이블 목록 -->
	<h1>titles 테이블 목록</h1>
	<%
		// 현재 페이지
		int currentPage = 1;

		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		int rowPerPage = 10;
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://unuho.kro.kr/employees", "goodee", "java1004");
		System.out.println(conn +"<- conn");
		
		String sql = "select emp_no, title, from_date, to_date from titles order by emp_no asc limit ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, (currentPage-1)*rowPerPage);
		stmt.setInt(2, rowPerPage);
		System.out.println(stmt + "<- stmt");
		
		ResultSet rs = stmt.executeQuery();
		System.out.println(rs + "<- rs");
		
		String sql2 = "select count(*) from titles";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		ResultSet rs2 = stmt2.executeQuery();
		
		int totalCount = 0;
		if(rs2.next()){
			totalCount = rs2.getInt("count(*)");
		}
		
		int lastPage = totalCount / rowPerPage;
		
		if(totalCount % rowPerPage != 0){ // 나머지가 있다면 나머지를 보여주기 위한 페이지가 하나 더 필요
			lastPage += 1;
		}
	%>
	
	<!-- 출력 -->
	<table border="1">
		<thead>
			<tr>
				<th>emp_no</th>
				<th>title</th>
				<th>from_date</th>
				<th>to_date</th>
			</tr>
		</thead>
		<tbody>
		<%
			while(rs.next()){
		%>
			<tr>
				<td><%=rs.getInt("emp_no") %></td>
				<td><%=rs.getString("title") %></td>
				<td><%=rs.getString("from_date") %></td>
				<td><%=rs.getString("to_date") %></td>
			</tr>
		<%
			}
		%>
		</tbody>
	</table>
	<!-- 페이징 네비게이션 -->
		<%
			if(currentPage != 1){
		%>
			<a href="./titlesList.jsp?currentPage=1">처음으로</a>
		<%
			}
		%>
		<%
			if(currentPage > 1){
		%>
			<a href="./titlesList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
			}
		%>
		<!-- 이슈 : 마지막 페이지는 더 이상 다음이라는 링크가 존재x -->
		<%
			if(currentPage < lastPage){
		%>
				<a href="./titlesList.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%
			}
		%>
			<a href="./titlesList.jsp?currentPage=<%=lastPage%>">마지막으로</a>
</body>
</html>