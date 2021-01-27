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
		      	<a class="nav-link disabled" href="./deptManagerList.jsp">DEPT_MANAGER 목록</a>
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
	
	<!-- dept_manager 테이블 목록 -->
	<h1>dept_manager 테이블 목록</h1>
	<%
		String deptNo = "";
		if(request.getParameter("deptNo") != null){
			deptNo = request.getParameter("deptNo");
		}
		
		String ck = "no";
		if(request.getParameter("ck") != null){
			ck = request.getParameter("ck");
		}
		
		int currentPage = 1;
		
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		int rowPerPage = 10;
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://unuho.kro.kr/employees", "goodee", "java1004");
		System.out.println(conn +"<- conn");
		
		String sql = "";
		String sql2 = "";
		PreparedStatement stmt = null;
		PreparedStatement stmt2 = null;
		
		// 동적쿼리
		// 1. 재직x, 부서x
		if(ck.equals("no") && deptNo.equals("")){
			sql = "select dept_no, emp_no, from_date, to_date from dept_manager order by dept_no asc limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*10);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_manager order by dept_no asc";
			stmt2 = conn.prepareStatement(sql2);
		// 2. 재직o, 부서x
		}else if(ck.equals("yes") && deptNo.equals("")){
			sql = "select dept_no, emp_no, from_date, to_date from dept_manager where to_date = '9999-01-01' order by dept_no asc limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*10);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_manager where to_date = '9999-01-01' order by dept_no asc";
			stmt2 = conn.prepareStatement(sql2);
		// 3. 재직x, 부서o
		}else if(ck.equals("no") && !deptNo.equals("")){
			sql = "select dept_no, emp_no, from_date, to_date from dept_manager where dept_no = ? order by dept_no asc limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, deptNo);
			stmt.setInt(2, (currentPage-1)*10);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) from dept_manager where dept_no = ? order by dept_no asc";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, deptNo);
		// 4. 재직o, 부서o
		}else{
			sql = "select dept_no, emp_no, from_date, to_date from dept_manager where dept_no = ? and to_date = '9999-01-01' order by dept_no asc limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, deptNo);
			stmt.setInt(2, (currentPage-1)*10);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) from dept_manager where dept_no = ? and to_date = '9999-01-01' order by dept_no asc";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, deptNo);
		}
		
		ResultSet rs = stmt.executeQuery();
		ResultSet rs2 = stmt2.executeQuery();
		
		String sql3 = "select dept_no from departments";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		ResultSet rs3 = stmt3.executeQuery();
		
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
	<form action="./deptManagerList.jsp">
		<%
			if(ck.equals("no")){
		%>
				<input type="checkbox" name="ck" value="yes">재직중 
		<%
			}else{
		%>
				<input type="checkbox" name="ck" value="yes" checked="checked">재직중
		<%
			}
		%>
		
		<select name="deptNo">
			<option value="">선택없음</option>
			<%
				while(rs3.next()){
					if(deptNo.equals(rs3.getString("dept_no"))){
			%>				
						<option value=<%=rs3.getString("dept_no")%> selected="selected"><%=rs3.getString("dept_no")%></option>
			<%
					}else{
			%>
						<option value=<%=rs3.getString("dept_no")%>><%=rs3.getString("dept_no")%></option>
			<%
					}
				}
			%>
		</select>
		<button type="submit">검색</button>
	</form>
	<table border="1">
		<thead>
			<tr>
				<th>dept_no</th>
				<th>emp_no</th>
				<th>from_date</th>
				<th>to_date</th>
			</tr>
		</thead>
		<tbody>
		<%
			while(rs.next()){
		%>
			<tr>
				<td><%=rs.getString("dept_no") %></td>
				<td><%=rs.getInt("emp_no") %></td>
				<td><%=rs.getString("from_date") %></td>
				<td><%=rs.getString("to_date") %></td>
			</tr>
		<%			
			}
		%>
		</tbody>
	</table>
		<!-- 페이징 네비게이션  -->
<table>
		<tr>
			<!-- 첫번째 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage != 1){
			%>
					<a href="./deptManagerList.jsp?currentPage=1&ck=<%=ck%>&deptNo=<%=deptNo%>">처음으로</a>
			<%
				}
			%>
			</td>
			<!-- 이전 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage > 1){
			%>
					<a href="./deptManagerList.jsp?currentPage=<%=currentPage - 1%>&ck=<%=ck%>&deptNo=<%=deptNo%>">이전</a>
			<%
				}
			%>
			</td>
			<!-- 다음 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage < lastPage){
			%>
					<a href="./deptManagerList.jsp?currentPage=<%=currentPage + 1%>&ck=<%=ck%>&deptNo=<%=deptNo%>">다음</a>
			<%
				}
			%>
			</td>
			<!-- 마지막 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage != lastPage){
			%>
					<a href="./deptManagerList.jsp?currentPage=<%=lastPage%>&ck=<%=ck%>&deptNo=<%=deptNo%>">마지막으로</a>
			<%
				}
			%>
			</td>
		</tr>
	</table>
</body>
</html>