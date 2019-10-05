<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.text.*,java.sql.*,javax.sql.*,javax.naming.*,java.util.* ,WatTimePack.*" %>
<%@ page import = "java.sql.Timestamp" %>
<%request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="memberDTO" class = "WatTimePack.WatTimeMemberDTO" scope="page">
   <jsp:setProperty name="memberDTO" property="*"/>
</jsp:useBean>
<jsp:useBean id="productDTO" class = "WatTimePack.WatTimeProductDTO" scope="page">
   <jsp:setProperty name="productDTO" property="*"/>
</jsp:useBean>
<jsp:useBean id="basketDTO" class = "WatTimePack.WatTimeBasketDTO" scope="page">
	<jsp:setProperty name="basketDTO" property="*"/>
</jsp:useBean>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="WTBuy/js/WTBuyForm.js"></script>
</head>
<%
	DecimalFormat df = new DecimalFormat("#,###");
	String productCode = request.getParameter("productCode");
	String productCount = request.getParameter("productCount");
	
	if(session.getAttribute("member") != null){
	    memberDTO = (WatTimeMemberDTO)session.getAttribute("member");
	}
	
	List<WatTimeBasketDTO> basketList = null;
	WatTimeBasketDAO basketDAO = new WatTimeBasketDAO();
	WatTimeProductDAO productDAO = new WatTimeProductDAO();
	
	//장바구니에 항목이 있는지 검사할 변수
	int count = 0;
	//장바구니 화면에서 구매를 눌렀을 때
	if(productCode == null&&productCount==null){
		productCode = "";
		productCount = "";
		basketList = basketDAO.getMemberBasketList(memberDTO.getMemId());
	}else{
		count = basketDAO.getBasketOverlapCheck(memberDTO.getMemId(),productCode);
		
		//상품 상세보기에서 구매하기를 눌렀는데 해당 상품이 장바구니 테이블에 있을 때
		if(count!=0){
			basketList = basketDAO.getMemberBasketList(memberDTO.getMemId());
		//상품 상세보기에서 구매하기를 눌렀는데 해당 상품이 장바구니 테이블에 없을 때
		}else{
			productDTO = productDAO.getProductSpec(productCode);
			basketDTO.setMemId(memberDTO.getMemId());
			basketDTO.setMemName(memberDTO.getMemName());
			basketDTO.setProductCode(productCode);
			basketDTO.setProductCount(Integer.parseInt(productCount));
			basketDTO.setProductName(productDTO.getProductName());
			basketDTO.setProductPrice(Integer.parseInt(productCount)*productDTO.getProductPrice());
			basketDTO.setProductSimpleImgFileName(productDTO.getProductSimpleImgFileName());
			basketDTO.setTictok(Integer.parseInt(productCount)*productDTO.getTictok());
			basketDTO.setBasketAddDate(new Timestamp(System.currentTimeMillis()));
			
			//장바구니 테이블에 먼저 insert
			basketDAO.setBasket(basketDTO);
			//insert 한 후 select
			basketList = basketDAO.getMemberBasketList(memberDTO.getMemId());
			
			productDAO.setProductVolumeChange(productCode,Integer.parseInt(productCount));
		}
	}
%>
<body>
	
	<form method="post" action="WTBuy/WTBuyPro.jsp" id="BuyForm" name="BuyForm">
		<table width="1300px" border="1">
			<th width="150px">
				이미지
			</th>
			<th width="650px">
				상품명
			</th>
			<th width="200px">
				가격
			</th>
			<th width="100px">
				수량
			</th>
			<th width="200px">
				적립금
			</th>
<%	
			int total = 0;
			int TicTok = 0;
			String firstProductName="";
			for(int i = 0 ; i < basketList.size() ; i++){
				if(i==0){
					basketDTO = basketList.get(i);
					firstProductName = basketDTO.getProductName();
				}
				basketDTO = basketList.get(i);
				total = total + basketDTO.getProductPrice();
				TicTok = TicTok + basketDTO.getTictok();
%>
				<tr>
					<!-- 상품 이미지 -->
					<td>
						<img src="../WatTime/img/brand/<%=basketDTO.getProductSimpleImgFileName() %>" 
							 width="150px" height="150px">
						<input type="hidden" name="productImg" value="<%=basketDTO.getProductSimpleImgFileName() %>">
					</td>
					<!-- 상품명 -->
					<td>
						<%=basketDTO.getProductName() %>
						<input type="hidden" name="product" value="<%=basketDTO.getProductName() %>">
						<input type="hidden" name="productCode" value="<%=basketDTO.getProductCode() %>">
					</td>
					<!-- 상품 가격 -->
					<td>
						<%=df.format(basketDTO.getProductPrice()) %>
						<input type="hidden" name="productPrice" value="<%=basketDTO.getProductPrice() %>">
					</td>
					<!-- 상품 갯수 -->
					<td>
						<%=basketDTO.getProductCount() %>
						<input type="hidden" name="productCount" value="<%=basketDTO.getProductCount() %>">
					</td>
					<!-- 적립금 -->
					<td>
						<%=df.format(basketDTO.getTictok()) %>
						<input type="hidden" name="TicTok" value="<%=basketDTO.getTictok() %>">
					</td>
				</tr>
<%
			}
%>
			<tr>
				<td>
					<input type="button" value="장바구니 목록" onclick="basketList()">
				</td>
				<td>
					총 가격 : <%=df.format(total) %><br>
					총 적립 TicTok : <%=df.format(TicTok) %>
				</td>
			</tr>
		</table>
		<!-- 주문자 정보 -->
		주문자 정보
		<table border="1">
			<tr>
				<td>
					이름
				</td>
				<td>
					<%=memberDTO.getMemName() %>
				</td>
			</tr>
			<tr>
				<td>
					이메일
				</td>
				<td>
					<input type="text" name="orderMemEmail" value="<%=memberDTO.getMemEmail() %>">
				</td>
			</tr>
			<tr>
				<td>
					전화번호
				</td>
				<td>
					<input type="text" name="orderMemPhone" value="<%=memberDTO.getMemPhone() %>">
				</td>
			</tr>
		</table>
		<!-- 위 정보 버튼을 누르면 들어가는 값 -->
		<input type="hidden" id="memName" value="<%=memberDTO.getMemName()%>">
		<input type="hidden" id="memPhone" value="<%=memberDTO.getMemPhone()%>">
		<input type="hidden" id="postCode" value="<%=memberDTO.getMemPostcode()%>">
		<input type="hidden" id="roadAddress" value="<%=memberDTO.getMemRoadAddress()%>">
 		<!-- 배송정보 -->
		배송정보
		<table border="1">
			<tr>
				<td>
					이름
				</td>
				<td>
					<input type="text" id="deliveryMemName" name="deliveryMemName">
					<input type="button" value="위 정보와 동일" onclick="contentSame()">
				</td>
			</tr>
			<tr>
				<td>
					전화번호
				</td>
				<td>
					<input type="text" id="deliveryMemPhone" name="deliveryMemPhone" placeholder="전화번호(-없이)">
				</td>
			</tr>
			<tr>
				<td>
					주소
				</td>
				<td>
					<input type="text" id="memPostcode" name="memPostcode" placeholder="우편번호" readonly>
					<input type="button" value="우편번호 찾기" onclick="postcode()"><br>
					<input type="text" id="memRoadAddress" name="memRoadAddress" placeholder="주소">
				</td>
			</tr>
			<tr>
				<td>
					주문 메세지
				</td>
				<td>
					<input type="text" id="deliveryMessage" name="deliveryMessage" value="부재시 전화주세요.">
				</td>
			</tr>
		</table>
		<!-- 포인트 사용 여부-->
		<table>
			<tr>
				<td>
					현재 가격 : <%=df.format(total) %>원
				</td>
			</tr>
			<tr>
				<td>
					보유 TicTok : <%=df.format(memberDTO.getMemPoint()) %><br>
					사용할 TicTok : <input type="number" id="useTicTok" name="useTicTok" value="0" 
										 onkeyup="totalPriceCul(this.value,'<%=total%>','<%=memberDTO.getMemPoint()%>')"
										 onkeydown="totalPriceCul(this.value,'<%=total%>','<%=memberDTO.getMemPoint()%>')"
								   >
					<input type="button" value="전부 사용" onclick="allTicTok('<%=memberDTO.getMemPoint()%>','<%=total%>')"><br>
					<font size="2px" color="gray">포인트는 1000TicTok부터 사용이 가능합니다.</font>
				</td>
			</tr>
			<tr>
				<td>
					최종가격 : <span id="totalPrice"><%=df.format(total) %></span><br>
					<input type="hidden" name="totalPrice" value="<%=total%>"> 
					적립 TicTok : <%=df.format(TicTok) %>
					<input type="hidden" name="TicTok" value="<%=TicTok%>"> 
				</td>
			</tr>
		</table>
		<!-- 결제방법 -->
		<table>
			<!-- 신용카드 -->
			<tr>
				<td>
					<input type="radio" id="check1" name="check" value="card"> 신용카드<br>
					<input type="radio" id="check2" name="check" value="bankDeposit"> 휴대폰 결제<br>
					<input type="radio" id="check3" name="check" value="accountTransfer"> 실시간 계좌이체
				</td>
			</tr>
		</table>
<%
		//결제 페이지에서 결제하는 상품의 갯수가 1개 초과
		if(basketList.size()>1){
%>
			<input type="hidden" id="productTitle" name="productTitle" value="<%=firstProductName %> 외 <%=basketList.size()-1%>개">
<%
		}else{
%>
			<input type="hidden" id="productTitle" name="productTitle" value="<%=firstProductName %>">
<%
		}
%>
		<input type="button" value="결제하기" onclick="order()">
		<!-- 결제 팝업창 정보 보내기 -->
		<!-- 시리얼 번호 -->
		<input type="hidden" id="serialNumber" name="serialNumber">
		<!-- 할부 기간 -->
		<input type="hidden" id="installments" name="installments">
		<!-- 은행 -->
		<input type="hidden" id="bank" name="bank">
		<!-- 결제 방법 -->
		<input type="hidden" id="paymentMethod" name="paymentMethod">
	</form>
</body>
</html>