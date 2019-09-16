<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*,javax.sql.*,javax.naming.*,java.util.* ,WatTimePack.*" %>
<jsp:useBean id="noticeDTO" class = "WatTimePack.WatTimeNoticeDTO" scope="page">
	<jsp:setProperty name="noticeDTO" property="*"/>
</jsp:useBean>
<%request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language = "JavaScript" src = "WTNotice/js/WTNoticeList.js"></script>
<title>Insert title here</title>
<%
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	
	int pageSize = 10;

	int currentPage = pageNum;

	int startRow = (currentPage - 1) * pageSize + 1;

	int endRow = pageSize;
	//테이블에 조건에 맞는 행이 몇개인지 알아낼려는 변수
	int count = 0;
	//???
	int number = 0;
	
	WatTimeNoticeDAO noticeDAO = new WatTimeNoticeDAO();
	
    count = noticeDAO.getNoticeCount();
    number = count-(currentPage-1)*pageSize;
    
    List<WatTimeNoticeDTO> noticeList = null;
    noticeList = noticeDAO.getNoticeList(startRow, endRow);
%>
</head>
<body>
	<div>
		<input type="button" id="faq" name="faq" value="FAQ" onclick="FAQPage()">
		<input type="button" id="notice" name="notice" value="공지사항" onclick="noticePage()">
		<input type="button" id="review" name="review" value="구매후기" onclick="reviewPage()">
	</div>
	<input type="button" value="글쓰기" onclick="noticeWriteForm()">
	<table border="1">
		<th width="50px">번호</th>
		<th width="500px">제목</th>
		<th width="150px">작성자</th>
		<th width="200px">작성일</th>

<%
		if(noticeList.size() == 0){
%>
			<tr>
				<td colspan=4>공지사항이 없습니다.</td>
			<tr>
<%
		}else{
			for(int i = 0 ; i < noticeList.size() ; i++){
				noticeDTO = noticeList.get(i);
				
%>	
			<tr onclick="noticeListClick('<%=noticeDTO.getNum() %>','<%=pageNum%>')">
				<!-- 번호 -->
				<td><%=noticeDTO.getNum() %></td>
				<!-- 제목 -->
				<td><%=noticeDTO.getTitle() %></td>
				<!-- 작성자 -->
				<td><%=noticeDTO.getWriter() %></td>
				<!-- 작성일 -->
				<td><%=noticeDTO.getWriteDate() %></td>
			</tr>
<%
			}
		}
%>
	</table>
<%
	//테이블의 행이 0 초과일 경우
	if (count > 0) {
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		int startPage = 1 ;
		
		if(currentPage % 5 != 0){
			startPage = (int)(currentPage/5)*2 + 1;
		}else{
			startPage = ((int)(currentPage/5)-1)*5 + 1;
		}
		int pageBlock = 5;
		int endPage = startPage + pageBlock - 1;
		if (endPage > pageCount){
			endPage = pageCount;
		}
        if (startPage > 5) { 
%>
			<input type="button" name="back" value="이전" onclick="back('<%=startPage - 5%>')">
<%      
		}
        for (int i = startPage ; i <= endPage ; i++) {  
%>
        	<input type="button" name="pageNum" value="<%=i %>" onclick="pageNum(this.value)">
<%      
		}
        
        if (endPage < pageCount) {  %>
        	<input type="button" name="back" value="다음" onclick="next('<%=startPage + 5%>')">
<%
        }
    }
%>
</body>
</html>