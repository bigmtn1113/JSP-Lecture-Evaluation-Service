package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class EvaluationDao {

	private DataSource ds;
	
	public EvaluationDao() {
		try {
			Context context = new InitialContext();
			ds = (DataSource) context.lookup("java:comp/env/jdbc/Oracle11g");
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}
	
	public int write(EvaluationDto evaluation) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			String query = "insert into evaluation values (evaluation_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, evaluation.getUserId());
			pstmt.setString(2, evaluation.geteLectureName());
			pstmt.setString(3, evaluation.geteProfessorName());
			pstmt.setInt(4, evaluation.geteLectureYear());
			pstmt.setString(5, evaluation.geteSemesterDivide());
			pstmt.setString(6, evaluation.geteLectureDivide());
			pstmt.setString(7, evaluation.geteTitle());
			pstmt.setString(8, evaluation.geteContent());
			pstmt.setString(9, evaluation.geteTotalScore());
			pstmt.setString(10, evaluation.geteCreditScore());
			pstmt.setString(11, evaluation.geteComfortableScore());
			pstmt.setString(12, evaluation.geteLectureScore());
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null) con.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return -1; // db 오류
	}
	
	public ArrayList<EvaluationDto> getList(String eLectureDivide, String searchType, String search, int pageNumber) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<EvaluationDto> evaluationList = null;
		String query = "";
		
		if (eLectureDivide.equals("전체"))
			eLectureDivide = "";
		
		try {
			if (searchType.equals("최신순"))
				query = "select * from (select row_number() over(order by eId desc) num, a.* from evaluation a "
						+ "where eLectureDivide like ? and (eLectureName || eProfessorName || eTitle || eContent) "
						+ "like ?) where num between " + pageNumber * 5 + 1 + " and " + pageNumber * 5 + 6; 
			else if (searchType.equals("추천순"))
				query = "select * from (select row_number() over(order by eLikeCount desc) num, a.* from evaluation a "
						+ "where eLectureDivide like ? and (eLectureName || eProfessorName || eTitle || eContent) "
						+ "like ?) where num between " + pageNumber * 5 + 1 + " and " + pageNumber * 5 + 6;
			
			con = ds.getConnection();
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, "%" + eLectureDivide + "%");
			pstmt.setString(2, "%" + search + "%");
			rs = pstmt.executeQuery();
			
			evaluationList = new ArrayList<EvaluationDto>();
			while (rs.next()) {
				EvaluationDto evaluation = new EvaluationDto(
						rs.getInt("eId"),
						rs.getString("userId"),
						rs.getString("eLectureName"),
						rs.getString("eProfessorName"),
						rs.getInt("eLectureYear"),
						rs.getString("eSemesterDivide"),
						rs.getString("eLectureDivide"),
						rs.getString("eTitle"),
						rs.getString("eContent"),
						rs.getString("eTotalScore"),
						rs.getString("eCreditScore"),
						rs.getString("eComfortableScore"),
						rs.getString("eLectureScore"),
						rs.getInt("eLikeCount")
						);
				evaluationList.add(evaluation);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null) con.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return evaluationList;
	}
	
	public int like(String eId) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			String query = "update evaluation set eLikeCount = eLikeCount + 1 where eId = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, Integer.parseInt(eId));
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null) con.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return -1; // db 오류
	}
	
	public int delete(String eId) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			String query = "delete from evaluation where eId = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, Integer.parseInt(eId));
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null) con.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return -1; // db 오류
	}
	
	public String getUserId(String eId) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = ds.getConnection();
			String query = "select userId from evaluation where eId = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, Integer.parseInt(eId));
			rs =  pstmt.executeQuery();
			
			if (rs.next())
				return rs.getString(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (con != null) con.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return null; // 존재하지 않는 강의 평가글
	}
}
