<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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
		      	<a class="nav-link disabled" href="./employeesList.jsp">EMPLOYEES 목록</a>
		    </li>
		    <li class="nav-item">
		      	<a class="nav-link" href="./salariesList.jsp">SALARIES 목록</a>
		    </li>
		    <li class="nav-item">
		      	<a class="nav-link" href="./titlesList.jsp">TITLES 목록</a>
		    </li>
	  	</ul>
	</nav>
	
	<!-- employees 테이블 목록 -->
	<h1>employees 테이블 목록</h1>
	<%
		// 성별 / 이름 찾기 변수
		String searchGender = "선택안함";
		if(request.getParameter("searchGender") != null){
			searchGender = request.getParameter("searchGender");
		}
		
		String searchName = "";
		if(request.getParameter("searchName") != null){
			searchName = request.getParameter("searchName");
		}
	
		// 현재 페이지 1로 지정
		int currentPage = 1;
	
		//null값인지 확인
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
			
		int rowPerPage = 10;
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://unuho.kro.kr/employees", "goodee", "java1004");
		String sql = "";
		String sql2 = "";
		
		// if문 밖에서 선언해야 ResultSet이 실행됨
		PreparedStatement stmt = null;
		PreparedStatement stmt2 = null;
		
		// 동적쿼리(4가지 중 1 선택)
		// 1. 성별 x, 이름 x
		if(searchGender.equals("선택안함") && searchName.equals("")){
			sql="select emp_no, birth_date, first_name, last_name, gender, hire_date from employees limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from employees";
			stmt2 = conn.prepareStatement(sql2);
			
		// 2. 성별o, 이름 x
		} else if(!searchGender.equals("선택안함") && searchName.equals("")){
			sql="select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where gender = ? limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, searchGender);
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) from employees where gender = ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, searchGender);
		// 3. 성별x, 이름o
		}else if(searchGender.equals("선택안함") && !searchName.equals("")){
			sql="select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where first_name like ? or last_name like ? limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchName+"%");
			stmt.setString(2, "%"+searchName+"%");
			stmt.setInt(3, (currentPage-1)*rowPerPage);
			stmt.setInt(4, rowPerPage);
			sql2 = "select count(*) from employees where first_name = ? or last_name = ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, "%"+searchName+"%");
			stmt2.setString(2, "%"+searchName+"%");
		// 4. 성별o, 이름o
		}else if(!searchGender.equals("선택안함") && !searchName.equals("")){
			sql="select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where gender = ? and (first_name like ? or last_name like ?) limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, searchGender);
			stmt.setString(2, "%"+searchName+"%");
			stmt.setString(3, "%"+searchName+"%");
			stmt.setInt(4, (currentPage-1)*rowPerPage);
			stmt.setInt(5, rowPerPage);
			sql2 = "select count(*) from employees where gender = ? and (first_name like ? or last_name like ?)";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, searchGender);
			stmt2.setString(2, "%"+searchName+"%");
			stmt2.setString(3, "%"+searchName+"%");
		}
		
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
	
	<table border="1">
		<thead>
			<tr>
				<th>emp_no</th>
				<th>birth_date</th>
				<th>age</th>
				<th>first_name</th>
				<th>last_name</th>
				<th>gender</th>
				<th>hire_date</th>
			</tr>
		</thead>
		<tbody>
			<%
				int age;
				int year = Calendar.getInstance().get(Calendar.YEAR);
				
				while(rs.next()){
					
					String[] date = rs.getString("birth_date").split("-");
					age = year - Integer.parseInt(date[0]) + 1;
			%>
				<tr>
					<td><%=rs.getInt("emp_no")%></td>
					<td><%=rs.getString("birth_date")%></td>
					<td><%=age%></td>
					<td><%=rs.getString("first_name")%></td>
					<td><%=rs.getString("last_name")%></td>
					<td>
					<%
						if(rs.getString("gender").equals("M")){
					%>
						남자
					<%
						}else{
					%>
						여자
					<%
						}
					%>
					</td>
					<td><%=rs.getString("hire_date")%></td>
				</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<!-- 페이징 네비게이션 -->
	<table>
		<tr>
			<!-- 첫번째 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage != 1){
			%>
					<a href="./employeesList.jsp?currentPage=1&searchGender=<%=searchGender%>&searchName=<%=searchName%>">처음으로</a>
			<%
				}
			%>
			</td>
			<!-- 이전 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage > 1){
			%>
					<a href="./employeesList.jsp?currentPage=<%=currentPage - 1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">이전</a>
			<%
				}
			%>
			</td>
			<!-- 다음 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage < lastPage){
			%>
					<a href="./employeesList.jsp?currentPage=<%=currentPage + 1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">다음</a>
			<%
				}
			%>
			</td>
			<!-- 마지막 페이지로 가는 버튼 -->
			<td>
			<%
				if(currentPage != lastPage){
			%>
					<a href="./employeesList.jsp?currentPage=<%=lastPage%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">마지막으로</a>
			<%
				}
			%>
			</td>
		</tr>
	</table>
	<form method="post" action="./employeesList.jsp">
		<div>
			gender : 
			<select name="searchGender">
				<%	
					// 선택안함으로 선택했을 경우 select에 선택안함으로 고정
					if(searchGender.equals("선택안함")){
				%>
					<option value="선택안함" selected="selected">선택안함</option>
				<%
					} else {
				%>
					<option value="선택안함">선택안함</option>
				<%
					}
				// '남'으로 선택했을 경우 select에 '남'으로 고정
					if(searchGender.equals("M")){
				%>
						<option value="M" selected="selected">남</option>
				<%
					} else{
				%>
						<option value="M">남</option>
				<%
					}
					// '여'로 선택했을 경우 select에 '여'로 고정
					if(searchGender.equals("F")){
				%>
						<option value="F" selected="selected">여</option>
				<%
					} else {
				%>
						<option value="F">여</option>
				<%
					}
				%>
			</select>
			
			name : 
			<input type="text" name="searchName" value="<%=searchName%>">
			
			<button type="submit">검색</button>
		</div>
	</form>
</body>
</html>