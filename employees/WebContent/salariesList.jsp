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
		      	<a class="nav-link disabled" href="./salariesList.jsp">SALARIES 목록</a>
		    </li>
		    <li class="nav-item">
		      	<a class="nav-link" href="./titlesList.jsp">TITLES 목록</a>
		    </li>
	  	</ul>
	</nav>
	
	<div>
	<!-- salaries 테이블 목록 -->
	<%
		int beginSalary = 0;
		int endSalary = 0;
		int maxSalary = 0;
		
		// 기본 페이지 1로 지정
		int currentPage = 1;
		
		// null값인지 구분
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		int rowPerPage = 10;
		
		// mariadb 연결
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://unuho.kro.kr/employees", "goodee", "java1004");
		System.out.println(conn +"<- conn");
		
		// 최대 연봉 구하는 쿼리
		String sql1 = "select max(salary) from salaries";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		ResultSet rs1 = stmt1.executeQuery();
		
		if(rs1.next()){
			maxSalary = rs1.getInt("max(salary)"); //max(salary) = 158,220
			endSalary = maxSalary; // endSalary가 null일 경우 maxSalary 값 대입
		}
		if(request.getParameter("beginSalary") != null){
			beginSalary = Integer.parseInt(request.getParameter("beginSalary"));
		}
		if(request.getParameter("endSalary") != null){ //endSalary가 null이 아닐 경우
			endSalary = Integer.parseInt(request.getParameter("endSalary"));
		}
		
		// 쿼리문 생성
		int range = 10000;
		String sql2 = "select emp_no, salary, from_date, to_date from salaries where salary between ? and ? limit ?, ?";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		stmt2.setInt(1, beginSalary);
		stmt2.setInt(2, endSalary);
		stmt2.setInt(3, (currentPage-1)*rowPerPage);
		stmt2.setInt(4, rowPerPage);
		System.out.println(stmt2 + "<- stmt");
		
		// 쿼리 실행
		ResultSet rs2 = stmt2.executeQuery();
		System.out.println(rs2 + "<- rs");
		
		// 총 테이블 개수
		String sql3 = "select count(*) from salaries where salary between ? and ?";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		stmt3.setInt(1, beginSalary);
		stmt3.setInt(2, endSalary);
		ResultSet rs3 = stmt3.executeQuery();
		
		int totalCount = 0;
		if(rs3.next()){
			totalCount = rs3.getInt("count(*)");
		}
		
		int lastPage = totalCount / rowPerPage;
		
		if(totalCount % rowPerPage != 0){ // 나머지가 있다면 나머지를 보여주기 위한 페이지가 하나 더 필요
			lastPage += 1;
		}
		
	%>
	
	<!-- 출력 -->
	<div style="padding-top:20px;" class="container">
		<h1>salaries 테이블 목록</h1>
		<table class="table">
			<thead>
				<tr>
					<th>emp_no</th>
					<th>salary</th>
					<th>from_date</th>
					<th>to_date</th>
				</tr>
			</thead>
			<tbody>
			<%
				while(rs2.next()){
			%>
				<tr>
					<td><%=rs2.getInt("emp_no") %></td>
					<td><%=rs2.getInt("salary") %></td>
					<td><%=rs2.getString("from_date") %></td>
					<td><%=rs2.getString("to_date") %></td>
				</tr>
			<%
				}
			%>
			</tbody>
		</table>
		<form method="post" action="./salariesList.jsp">
			<select class="custom-select" style="width:30%;" name="beginSalary">
				<%
					for(int i=0; i<maxSalary; i=i+10000){
						if(beginSalary == i){
				%>
						<option value="<%=i%>" selected="selected"><%=i%></option>
				<%
						}else{
				%>
						<option value="<%=i%>"><%=i%></option>
				<%
						}
					}
				%>
			</select>
			<select class="custom-select" style="width:30%;" name="endSalary">
				<%
					for(int i=(maxSalary / range + 1)*range; i>0; i=i-10000){
						if(endSalary == i){
				%>
						<option value="<%=i%>" selected="selected"><%=i%></option>
				<%
						}else{
				%>
						<option value="<%=i%>"><%=i%></option>
				<%
						}
					}
				%>
			</select>
			<button class="btn btn-secondary" type="submit">검색</button>
		</form>
			<!-- 페이징 네비게이션 -->
			<ul style="margin-top:20px;" class="pagination justify-content-center">
				<%
					if(currentPage != 1){
				%>
				<li class="page-item"><a class="page-link" href="./salariesList.jsp?currentPage=1&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">처음으로</a></li>
				<% 
					}
				%>
				<%
					if(currentPage > 1){
				%>
					<li class="page-item"><a class="page-link" href="./salariesList.jsp?currentPage=<%=currentPage-1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">이전</a></li>
				<%
					}
				%>
				<!-- 이슈 : 마지막 페이지는 더 이상 다음이라는 링크가 존재x -->
				<%
					if(currentPage < lastPage){
				%>
					<li class="page-item"><a class="page-link" href="./salariesList.jsp?currentPage=<%=currentPage+1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">다음</a></li>
				<%
					}
					if(currentPage != lastPage){
				%>
					<li class="page-item"><a class="page-link" href="./salariesList.jsp?currentPage=<%=lastPage%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">마지막으로</a></li>
				<% 
					}
				%>
			</ul>
		</div>
	</div>
</body>
</html>