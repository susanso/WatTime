package WatTimePack;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

import WatTimePack.WatTimeDBConnection;
import WatTimePack.WatTimeMemberDTO;

public class WatTimeMemberDAO {
	
	//로그인 관련
	public WatTimeMemberDTO getMember(String memId, String memPass) {
		WatTimeMemberDTO rslt = new WatTimeMemberDTO();
		try(Connection con = WatTimeDBConnection.getInstance().getConnection()){
			PreparedStatement pstmt = con.prepareStatement("select * from memberTbl where memId = ? and memPass = ?");
			pstmt.setString(1, memId);
			pstmt.setString(2, memPass);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				rslt = registerBeanMapper(rs);
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
		return rslt;
	}
	//아이디 찾기
	public WatTimeMemberDTO getMemberFindId(String memName, String memEmail, String memPhone) {
		WatTimeMemberDTO rslt = new WatTimeMemberDTO();
		try(Connection con = WatTimeDBConnection.getInstance().getConnection()){
			PreparedStatement pstmt = con.prepareStatement("select * from memberTbl where memName = ? and memEmail = ? and memPhone = ?");
			pstmt.setString(1, memName);
			pstmt.setString(2, memEmail);
			pstmt.setString(3, memPhone);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				rslt = registerBeanMapper(rs);
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
		return rslt;
	}
	//패스워드 찾기
	public WatTimeMemberDTO getMemberFindPass(String memId, String memEmail, String memPhone) {
		WatTimeMemberDTO rslt = new WatTimeMemberDTO();
		try(Connection con = WatTimeDBConnection.getInstance().getConnection()){
			PreparedStatement pstmt = con.prepareStatement("select * from memberTbl where memId = ? and memEmail = ? and memPhone = ?");
			pstmt.setString(1, memId);
			pstmt.setString(2, memEmail);
			pstmt.setString(3, memPhone);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				rslt = registerBeanMapper(rs);
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
		return rslt;
	}
	//새 패스워드 적용
	public WatTimeMemberDTO setMemberNewPass(String memPass, String memId) {
		WatTimeMemberDTO rslt = new WatTimeMemberDTO();
		try(Connection con = WatTimeDBConnection.getInstance().getConnection()){
			PreparedStatement pstmt = con.prepareStatement("update memberTbl set memPass = ? where memId = ?");
			pstmt.setString(1, memPass);
			pstmt.setString(2, memId);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
		return rslt;
	}
	
	
	private WatTimeMemberDTO registerBeanMapper(ResultSet rs) throws SQLException {
		WatTimeMemberDTO regBean = new WatTimeMemberDTO();
		//
		regBean.setMemId(rs.getString("memId"));
		regBean.setMemPass(rs.getString("memPass"));
		regBean.setMemName(rs.getString("memName"));
		regBean.setMemEmail(rs.getString("memEmail"));
		regBean.setMemPhone(rs.getString("memPhone"));
		regBean.setMemBirth(rs.getString("memBirth"));
		regBean.setMemPostcode(rs.getString("memPostcode"));
		regBean.setMemRoadAddress(rs.getString("memRoadAddress"));
		regBean.setMemJibunAddress(rs.getString("memJibunAddress"));
		regBean.setMemDetailAddress(rs.getString("memDetailAddress"));
		regBean.setMemEtcAddress(rs.getString("memEtcAddress"));
		regBean.setMemPoint(rs.getInt("memPoint"));
		regBean.setMemAdmin(rs.getInt("memAdmin"));
		regBean.setMemJoinDate(rs.getTimestamp("memJoinDate"));
		return regBean;
	}
	
	public List<WatTimeMemberDTO> getMemList() {
		List<WatTimeMemberDTO> list = new ArrayList<>();
		try(Connection con = WatTimeDBConnection.getInstance().getConnection()){
			PreparedStatement pstmt = con.prepareStatement("select * from memberTbl");
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				list.add(registerBeanMapper(rs));
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
		return list;
	}
	//아이디 중복 체크를 위한 메소드
	public WatTimeMemberDTO getMemberIdOverlapCheck(String memId) {
		WatTimeMemberDTO rslt = new WatTimeMemberDTO();
		try(Connection con = WatTimeDBConnection.getInstance().getConnection()){
			PreparedStatement pstmt = con.prepareStatement("select * from memberTbl where memId = ?");
			pstmt.setString(1, memId);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				rslt = registerBeanMapper(rs);
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
		return rslt;
	}
	
	//회원가입
	public WatTimeMemberDTO setMemberJoin(String memId, String memPass, String memName,String memEmail,String memPhone, String memBirth , String memPostcode, String memRoadAddress,String memJibunAddress, String memEtcAddress, String memDetailAddress) {
		WatTimeMemberDTO rslt = new WatTimeMemberDTO();
		try(Connection con = WatTimeDBConnection.getInstance().getConnection()){
			Timestamp memJoinDate = new Timestamp(System.currentTimeMillis());
			int memPoint = 2000;
			int memAdmin = 0;
			PreparedStatement pstmt = con.prepareStatement("insert into memberTbl values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			pstmt.setString(1, memId);
			pstmt.setString(2, memPass);
			pstmt.setString(3, memName);
			pstmt.setString(4, memEmail);
			pstmt.setString(5, memPhone);
			pstmt.setString(6, memBirth);
			pstmt.setString(7, memPostcode);
			pstmt.setString(8, memRoadAddress);
			pstmt.setString(9, memJibunAddress);
			pstmt.setString(10, memEtcAddress);
			pstmt.setString(11, memDetailAddress);
			pstmt.setInt(12, memPoint);
			pstmt.setInt(13, memAdmin);
			pstmt.setTimestamp(14, memJoinDate);
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
		return rslt;
		
	}
	//포인트 적립
	public WatTimeMemberDTO setUpdateTicTok(WatTimeMemberDTO memberDTO) {
		ResultSet rs = null;
		try(Connection con = WatTimeDBConnection.getInstance().getConnection()){
			PreparedStatement pstmt = con.prepareStatement("update memberTbl set memPoint = ? where memId = ?");
			pstmt.setInt(1, memberDTO.getMemPoint());
			pstmt.setString(2, memberDTO.getMemId());
			pstmt.executeUpdate();
			
			pstmt = con.prepareStatement("select * from memberTbl where memId=?");
			pstmt.setString(1, memberDTO.getMemId());
			rs = pstmt.executeQuery();
			while(rs.next()) {
				memberDTO.setMemId(rs.getString("memId"));
				memberDTO.setMemPass(rs.getString("memPass"));
				memberDTO.setMemName(rs.getString("memName"));
				memberDTO.setMemEmail(rs.getString("memEmail"));
				memberDTO.setMemPhone(rs.getString("memPhone"));
				memberDTO.setMemBirth(rs.getString("memBirth"));
				memberDTO.setMemPostcode(rs.getString("memPostcode"));
				memberDTO.setMemRoadAddress(rs.getString("memRoadAddress"));
				memberDTO.setMemJibunAddress(rs.getString("memJibunAddress"));
				memberDTO.setMemDetailAddress(rs.getString("memDetailAddress"));
				memberDTO.setMemEtcAddress(rs.getString("memEtcAddress"));
				memberDTO.setMemPoint(rs.getInt("memPoint"));
				memberDTO.setMemAdmin(rs.getInt("memAdmin"));
				memberDTO.setMemJoinDate(rs.getTimestamp("memJoinDate"));
			}
			
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
		return memberDTO;
	}
}
