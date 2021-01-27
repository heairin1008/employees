<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
	#main{ 
    margin-left:50px;
    margin-top:50px;
}
</style>
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
	
	<!-- 홈페이지(메인) 내용  -->
	<div id="main">
		<h1>EMPLOYEES 미니 프로젝트</h1>
		<h4>2020.09</h4>
		<ul>
			<li>jsp만을 사용해 제작한 직원 관리 프로젝트</li>
			<li>제작 : eclipse, tomcat 8.5, mariaDB 사용</li>
			<li>css : bootstrap 사용</li>
		</ul>
	</div>
</body>
</html>