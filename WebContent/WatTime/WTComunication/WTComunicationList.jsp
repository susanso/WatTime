<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*,javax.sql.*,javax.naming.*,java.util.* ,WatTimePack.*,java.text.*" %>
<%@ page import = "java.sql.Timestamp" %>
<%request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="comunicationDTO" class = "WatTimePack.WatTimeComunicationDTO" scope="page">
	<jsp:setProperty name="comunicationDTO" property="*"/>
</jsp:useBean>
<jsp:useBean id="memberDTO" class = "WatTimePack.WatTimeMemberDTO" scope="page">
	<jsp:setProperty name="memberDTO" property="*"/>
</jsp:useBean>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="WTComunication/js/WTComunicationList.js"></script>
<link href = "style.css" rel = "stylesheet" type = "text/css">
<title>Insert title here</title>
</head>
<body>
<%
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	int listCount = Integer.parseInt(request.getParameter("listCount"));
	
	if(session.getAttribute("member") != null){
		memberDTO = (WatTimeMemberDTO)session.getAttribute("member");
	}
	
	List<WatTimeComunicationDTO> comunicationList = null;
	WatTimeComunicationDAO comunicationDAO = new WatTimeComunicationDAO();
	
	int pageSize = listCount;
	int currentPage = pageNum;
	int startRow = (currentPage - 1) * pageSize + 1;
    int brandstartRow = (currentPage - 1) * pageSize + 1;
    int endRow = pageSize;
    int count = 0;
    int number = 0;
	
    count = comunicationDAO.getComunicationListCount();
    number = count-(currentPage-1)*pageSize;
	if(count==0){
%>
		게시글이 없습니다.
		<input type="button" id="firstComunication" value="첫글쓰기" onclick="comunicationWriteForm()">
<%
  	}else{	
%>
	<div id="aa" style="width:1300px; margin: 30px auto;">
		<select onchange="comunicationListCount(this.options[this.selectedIndex].value,'<%=pageNum%>')">
			<option value="" selected disabled required>선택</option>
			<option value="10">10개씩 보기</option>
			<option value="20">20개씩 보기</option>
			<option value="30">30개씩 보기</option>
		</select>
		<table id="comunicationList">
			<th width="100px" class="comunicationTh">번호</th>
			<th width="850px" class="comunicationTh">제목</th>
			<th width="150px" class="comunicationTh">작성자</th>
			<th width="200px" class="comunicationTh">작성일</th>
<%
			comunicationList = comunicationDAO.getComunicationRecommendationList();
			for (int i = 0 ; i < comunicationList.size() ; i++) {
			    comunicationDTO = comunicationList.get(i);
%>
				<tr onclick="comunicationForm('<%=comunicationDTO.getNum() %>','<%=comunicationDTO.getMemId()%>','<%=pageNum%>','<%=listCount%>')">
					
						<td class="comunicationTd" style="text-align:center;"><font color="red"><strong>추천</strong></font></td>
						<!-- 게시글 제목 -->
						<td class="comunicationTd" style="padding-left:20px;">
			  				<strong><%=comunicationDTO.getTitle() %></strong>
		  				</td>
		  				<!-- 게시글 작성자 -->
						<td class="comunicationTd" style="text-align:center;">
							<strong><%=comunicationDTO.getMemName() %></strong>
						</td>
						<!-- 게시글 작성일 -->
						<td class="comunicationTd" style="text-align:center;">
							<strong><%=sf.format(comunicationDTO.getWriteDate()) %></strong>
						</td>
				</tr>
<%
			}
%>
<%
			comunicationList = comunicationDAO.getComunicationList(startRow, pageSize);
			for (int i = 0 ; i < comunicationList.size() ; i++) {
			    comunicationDTO = comunicationList.get(i);
%>
			<tr onclick="comunicationForm('<%=comunicationDTO.getNum() %>','<%=comunicationDTO.getMemId()%>','<%=pageNum%>','<%=listCount%>')">
				<!-- 게시글 번호 -->
				<td class="comunicationTd" style="text-align:center;">
					<%=comunicationDTO.getNum() %>
				</td>
<%
				int wid=0; 
				if(comunicationDTO.getRe_level()>0){
				   wid=5*(comunicationDTO.getRe_level());
%>
					<!-- 게시글 제목 -->
					<td class="comunicationTd" style="padding-left:20px;">
						<img src="img/comu/level.png" width="<%=wid%>" height="16">
		  				<img src="img/comu//re.png">
		  				<%=comunicationDTO.getTitle() %>
	  				</td>
<%
				}else{
%>
					<!-- 게시글 제목 -->
					<td class="comunicationTd" style="padding-left:20px;">
		  				<%=comunicationDTO.getTitle() %>
	  				</td>
<%
				}
%>
				<!-- 게시글 작성자 -->
				<td class="comunicationTd"  style="text-align:center;">
					<%=comunicationDTO.getMemName() %>
				</td>
				<!-- 게시글 작성일 -->
				<td class="comunicationTd" style="text-align:center;">
					<%=sf.format(comunicationDTO.getWriteDate()) %>
				</td>
			</tr>
<%			
			}//--for 
%>
		<tr>
<%
			if(memberDTO.getMemId()!=null){
%>
				<td colspan="4" style="text-align:center;">
					<input type="button" class="ComunicationWriteBtn" name="newComunication" value="글쓰기" onclick="comunicationWriteForm()">
				</td>
<%
			}
%>
		</tr>
	</table>
	<div class="move">
<%
	}//--count !=0 else 

	if (count > 0) {
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		int startPage = 1 ;
		
		if(currentPage % 5 != 0){
			startPage = (int)(currentPage/5)*5 + 1;
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
			<input type="button" id="PageNum" name="back" value="이전" onclick="back('<%=startPage - 5%>','<%=listCount%>')">
<%      
	}
    	for (int i = startPage ; i <= endPage ; i++) {  
    		if(pageNum==i){
%>
				<input type="button" name="nowPageNum" id="nowPageNum" value="<%=i %>" onclick="pageNum(this.value,'<%=listCount %>')">
<%
			}else{
%>
    			<input type="button" name="pageNum" id="PageNum" value="<%=i %>" onclick="pageNum(this.value,'<%=listCount %>')">
<%      
			}
		}
    
       if (endPage < pageCount) {  %>
       		<input type="button" id="PageNum" name="back" value="다음" onclick="next('<%=startPage + 5%>','<%=listCount %>')">
<%
        }
    }
%>
	</div>
	<div class="noticeSearch">
	<select id="select">
		<option value="title">제목</option>
		<option value="titleContent">제목+내용</option>
		<option value="content">내용</option>
		<option value="memName">작성자</option>
	</select>
	<input type="text" id="comunicatoinSearchText" name="comunicatoinSearchText" onkeydown="textValue(this.value)" onkeyup="textValue(this.value)">
	<input type="button" id="searchButton" name="searchButton" value="검색" onclick="search()">
	</div>
	</div>
</body>
</html>