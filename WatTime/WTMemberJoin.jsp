<%@ page language = "java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<link href = "style.css" rel = "stylesheet" type = "text/css">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
	<script language = "JavaScript" src = "script.js"></script>
	<title>회원가입</title>

</head>
<body>
	<div class = "member">
		<div class="w3-container w3-blue">
		  <h2>회원가입</h2>
		</div>
		<div class="memberForm">
			<form class="w3-container" method = "post" id = "memJoinForm" name = "memJoinForm" action = "#">
				<!-- 아이디 -->
				<div class="memList">
					<div>
						<input class="inputText" type="text" id="memId" name="memId" placeholder="아이디(영문,숫자 6자~15자) " onkeydown="idOnkey()" required>
						<input type="button" id="idCheck" name="idCheck" value="중복확인" onclick="idOverlapCheck()">
					</div>
					<div><span id = "idCheckText" style="display:hidden;"></span></div>
					<div><input type="hidden" id="idHidden" name="idHidden" value="no"></div>
				</div>
				<!-- 비밀번호 -->
				<div class="memList">
					<div><input class="inputText" type="password" id="memPass" name="memPass" placeholder="패스워드(영문,숫자,특수문자 조합 8자 이상)" onblur="passCheck()" required></div>
					<div><input class="inputText" type="hidden" id="passHidden" name="passHidden" value="no"></div>
				<!-- 비밀번호 찾기 -->
					<div><input class="inputText" type="password" id="memPassCheck" name="memPassCheck" placeholder="패스워드 확인" onblur="passCheck()" required></div>
					<div><input class="inputText" type="hidden" id="passHidden" name="passHidden" value="no"></div>
					<div><span id = "passCheckText" style="display:hidden;"></span></div>
				</div>
				<!-- 이름 -->
				<div class="memList">
					<div><input class="inputText" type="text" id="memName" name="memName" placeholder="이름" onblur="nameCheck()" required></div>
					<div><input class="inputText" type="hidden" id="nameHidden" name="nameHidden" value="no"></div>
					<div><span id = "nameCheckText" style="display:hidden;"></span></div>
				</div>
				<!-- 이메일 -->
				<div class="memList">
					<div><input class="inputText" type="text" id="memEmail" name="memEmail" placeholder="이메일" onblur="emailCheck()" required></div>
					<div><input class="inputText" type="hidden" id="emailHidden" name="emailHidden" value="no"></div>
					<div><span id = "emailCheckText" style="display:hidden;"></span></div>
				</div>
				<!-- 전화번호-->
				<div class="memList">
					<div><input class="inputText" type="number" id="memPhone" name="memPhone" placeholder="전화번호" onblur="phoneCheck()" required></div>
					<div><input class="inputText" type="hidden" id="phoneHidden" name="phoneHidden" value="no"></div>
					<div><span id = "phoneCheckText" style="display:hidden;"></span></div>
				</div>
				<!-- 생년월일 -->
				<div class="memList">
					<div><input class="inputText" type="number" id="memBirth" name="memBirth" placeholder="생년월일" onblur="birthCheck()" required></div>
					<div><input class="inputText" type="hidden" id="birthHidden" name="birthHidden" value="no"></div>
					<div><span id = "birthCheckText" style="display:hidden;"></span></div>
				</div>
				<!-- 주소 -->
				<div>
					<input class="postText" type="text" id="memPostcode" size = "10" placeholder="우편번호" readonly>
					<input type="button" onclick="postcode()" value="우편번호 찾기">
				</div>
				<div>
					<input class="inputText" type="text" id="memRoadAddress" placeholder="도로명주소" readonly>
				</div>
				<div>
					<input class="inputText" type="text" id="memJibunAddress" placeholder="지번주소" readonly>
					
				</div>
				<div>
					<input class="inputText" type="text" id="memEtcAddress" placeholder="기타주소" readonly><br>
					<input class="inputText" type="text" id="memDetailAddress" placeholder="상세주소" onblur="addressCheck()">
				</div>
				<div>
					<input type="hidden" id="addressHidden" name="addressHidden" value="no">
				</div>
				<!-- 생성 및 취소 -->
				<input type="button" id="submit" name="submit" value="회원가입" onclick="joinMember()">
			</form>
		</div>
	</div>
</body>
</html>