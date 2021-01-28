<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>departmentsList</title>
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
		      	<a class="nav-link disabled" href="./departmentsList.jsp">DEPARTMENTS 목록</a>
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
		      	<a class="nav-link" href="./titlesList.jsp">TITLES 목록</a>
		    </li>
	  	</ul>
	</nav>
	
	<div style="padding-top:20px;" class="container">
	<h1>departments 테이블 목록</h1>
	<%
		String deptName = "";
		if(request.getParameter("deptName") != null){
			deptName = request.getParameter("deptName");
		}
		
		int currentPage = 1;
	
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		int rowPerPage = 10;
		
		// 1. mariadb(sw)를 사용할 수 있게
		Class.forName("org.mariadb.jdbc.Driver");
		// 2. mariadb 접속(주소+포트넘버+db이름, db계정, db계정암호)
		Connection conn = DriverManager.getConnection("jdbc:mariadb://unuho.kro.kr/employees", "goodee", "java1004");
		System.out.println(conn+"<- conn");
		
		// 3. conn 안에 쿼리(sql) 만듦
		String sql = "";
		String sql2 = "";
		PreparedStatement stmt = null;
		PreparedStatement stmt2 = null;
		
		//부서 검색
		if(deptName.equals("")){
			sql = "select dept_no, dept_name from departments limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from departments";
			stmt2 = conn.prepareStatement(sql2);
		}else {
			sql = "select dept_no, dept_name from departments where dept_name like ? limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%" + deptName + "%");
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) from departments where dept_name like ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, "%"+deptName+"%");
		}
		
		
		// 4. 쿼리에 결과물을 가지고 오기(쿼리 실행)
		ResultSet rs = stmt.executeQuery();
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
		<table class="table">
			<thead>
				<tr>
					<th>dept_no</th>
					<th>dept_name</th>
				</tr>
			</thead>
			<tbody>
				<%
					while(rs.next()){
				%>
					<tr>
						<td><%=rs.getString("dept_no") %></td>
						<td><%=rs.getString("dept_name") %></td>
					</tr>
				<%		
					}
				%>
			</tbody>
		</table>
		<form method="post" action="./departmentsList.jsp">
			<div>
				dept_name 
				<input class="form-control" style="width:50%; display:inline-block;" type="text" name="deptName" placeholder="검색" value=<%=deptName%>>
				<button class="btn btn-secondary" type="submit">검색</button>
			</div>
		</form>
		<!-- 페이징 네비게이션 -->
		<table>
		<tr>
			<!-- 첫번째 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage != 1){
			%>
					<a href="./departmentsList.jsp?currentPage=1&deptName=<%=deptName%>">처음으로</a>
			<%
				}
			%>
			</td>
			<!-- 이전 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage > 1){
			%>
					<a href="./departmentsList.jsp?currentPage=<%=currentPage - 1%>&deptName=<%=deptName%>">이전</a>
			<%
				}
			%>
			</td>
			<!-- 다음 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage < lastPage){
			%>
					<a href="./departmentsList.jsp?currentPage=<%=currentPage + 1%>&deptName=<%=deptName%>">다음</a>
			<%
				}
			%>
			</td>
			<!-- 마지막 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage != lastPage){
			%>
					<a href="./departmentsList.jsp?currentPage=<%=lastPage%>&deptName=<%=deptName%>">마지막으로</a>
			<%
				}
			%>
			</td>
		</tr>
	</table>
	</div>
</body>
</html>