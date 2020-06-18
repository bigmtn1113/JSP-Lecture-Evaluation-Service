package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
		return -1; // db ¿À·ù
	}
}
