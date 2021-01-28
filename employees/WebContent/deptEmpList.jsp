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
	
	<!-- dept_emp 테이블 목록 -->
	<%
		request.setCharacterEncoding("utf-8");
	
		//체크박스 변수
		String ck = "no";
		if(request.getParameter("ck") != null){
			ck = request.getParameter("ck"); // ck = "yes";
		}
		
		//select 부서 변수
		String deptNo = "";
		if(request.getParameter("deptNo") != null){
			deptNo = request.getParameter("deptNo");
		}
		
		//현재 페이지
		int currentPage = 1;
		
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		int rowPerPage = 10;
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://unuho.kro.kr/employees", "goodee", "java1004");
		System.out.println(conn + "<- conn");
		
		String sql = "";
		String sql2 = "";
		PreparedStatement stmt = null;
		PreparedStatement stmt2 = null;
		
		// 동적쿼리
		// 1. 체크x, 부서검색x
		if(ck.equals("no") && deptNo.equals("")){
			sql = "select emp_no, dept_no, from_date, to_date from dept_emp order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_emp order by emp_no desc";
			stmt2 = conn.prepareStatement(sql2);
		// 2. 체크o, 부서검색x
		}else if(ck.equals("yes") && deptNo.equals("")){
			sql = "select emp_no, dept_no, from_date, to_date from dept_emp where to_date = '9999-01-01' order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_emp where to_date = '9999-01-01'";
			stmt2 = conn.prepareStatement(sql2);
		// 3. 체크x, 부서검색o
		}else if(ck.equals("no") && deptNo.equals("")){
			sql = "select emp_no, dept_no, from_date, to_date from dept_emp where dept_no = ? order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, deptNo);
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) from dept_emp where dept_no = ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, deptNo);
		// 4. 체크o, 부서검색o
		}else{
			sql = "select emp_no, dept_no, from_date, to_date from dept_emp where dept_no = ? and to_date = '9999-01-01' order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, deptNo);
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) from dept_emp where dept_no = ? and to_date = '9999-01-01'";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, deptNo);
		}
		
		ResultSet rs = stmt.executeQuery();
		ResultSet rs2 = stmt2.executeQuery();
		
		// 테이블 총 개수
		int totalCount = 0;
		if(rs2.next()){
			totalCount = rs2.getInt("count(*)");
		}
		
		// 총 페이지 수 구하기
		int totalPage = totalCount / rowPerPage;
		if(totalCount % rowPerPage != 0){
			totalPage += 1;
		}
		
		// 한 번에 보여줄 페이지 개수 1~10 / 11~20 / ...
		int Section = 10;
		
		// 현재 페이지 섹션
		int currentSection = 1;
		if(request.getParameter("currentSection") != null){
			currentSection = Integer.parseInt(request.getParameter("currentSection"));
		}
		
		// 전체 섹션 개수
		int totalSection = totalPage / Section;
		if(totalPage % Section != 0){
			totalSection += 1;
		}
		
		// 이전 섹션(전 섹션의 10으로 이동)
		int prePage = (currentSection-1)*Section;
		
		// 다음 섹션(다음 섹션의 1로 이동)
		int nextPage = (currentSection+1)*Section-(Section-1);
		
		//현재 페이지의 시작 번호
		int firstSection = (currentSection * Section) - (Section - 1);
		
		//departments에 있는 dept_no 가져오기
		String sql3 = "select dept_no from departments";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		ResultSet rs3 = stmt3.executeQuery();
	%>
	
	<!-- 현재 부서에 근무중인지 어느 부서인지 검색 -->
	<div style="padding-top:20px;" class="container">
		<h1>dept_emp 테이블 목록</h1>
		<form action="./deptEmpList.jsp">
			<%
				if(ck.equals("no")){
			%>
					<input type="checkbox" name="ck" value="yes">현재 부서에 근무중
			<%
				}else{
			%>
					<input type="checkbox" name="ck" value="yes" checked="checked">현재 부서에 근무중
			<%
				}
			%>
			
			<select class="custom-select" style="width:30%;" name="deptNo">
				<option value="">선택안함</option>
				<%
					while(rs3.next()){
						if(deptNo.equals(rs3.getString("dept_no"))){
				%>
							<option value="<%=rs3.getString("dept_no")%>" selected="selected"><%=rs3.getString("dept_no")%></option>
				<%
						}else{
				%>
							<option value="<%=rs3.getString("dept_no")%>"><%=rs3.getString("dept_no")%></option>
				<%
						}
					}
				%>
			</select>
			<button class="btn btn-secondary" type="submit">검색</button>
		</form>
		<!-- dept_emp 목록 -->
		<table class="table" style="margin-top:10px;">
			<thead>
				<tr>
					<th>emp_no</th>
					<th>dept_no</th>
					<th>from_date</th>
					<th>to_date</th>
				</tr>
			</thead>
			<tbody>
			<%
				while(rs.next()){
			%>
				<tr>
					<td><%=rs.getInt("emp_no")%></td>
					<td><%=rs.getString("dept_no") %></td>
					<td><%=rs.getString("from_date") %></td>
					<td><%=rs.getString("to_date") %></td>
				</tr>
			<%
				}
			%>
			</tbody>
		</table>
		<div>
			<ul class="pagination justify-content-center">
				<!-- 페이징 네비게이션 -->
				<%
					//이전 버튼(현재 페이지가 1페이지가 아닐 때만 나타남)
					if(currentSection != 1){
				%>
						<li class="page-item"><a class="page-link" href="./deptEmpList.jsp?currentPage=<%=prePage%>&currentSection=<%=currentSection-1%>&ck=<%=ck%>&deptNo=<%=deptNo%>">이전</a></li>
				<%
					}
				%>
				<%
					//첫번째 섹션의 1번부터 10번까지 출력
					for(int i=firstSection; i<firstSection+Section; i++){
						if(currentPage == i){ // 현재 페이지가 현재 섹션의 1번일 경우
				%>
							<li class="page-item disabled"><a class="page-link" href="./deptEmpList.jsp?currentPage=<%=currentPage%>&currentSection=<%=currentSection%>&ck=<%=ck%>&deptNo=<%=deptNo%>"><%=i%></a></li>
				<%
					}else{ // 현재 페이지가 현재 섹션의 1번을 제외한 2~10번일 경우
				%>
							<li class="page-item"><a class="page-link" href="./deptEmpList.jsp?currentPage=<%=i%>&currentSection=<%=currentSection%>&ck=<%=ck%>&deptNo=<%=deptNo%>"><%=i%></a></li>
				<%
					}
					
				%>
					
				<%
					}
					//다음 버튼(현재 페이지가 마지막 페이지가 아닐 때만 나타남)
					if(currentSection != totalSection){
				%>
					<li class="page-item"><a class="page-link" href="./deptEmpList.jsp?currentPage=<%=nextPage%>&currentSection=<%=currentSection+1%>&ck=<%=ck%>&deptNo=<%=deptNo%>">다음</a></li>
				<%
				}
				%>
			</ul>
		</div>
	</div>
</body>
</html>