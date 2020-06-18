package evaluation;

public class EvaluationDto {

	private int eId;
	private String userId;
	private String eLectureName;
	private String eProfessorName;
	private int eLectureYear;
	private String eSemesterDivide;
	private String eLectureDivide;
	private String eTitle;
	private String eContent;
	private String eTotalScore;
	private String eCreditScore;
	private String eComfortableScore;
	private String eLectureScore;
	private int eLikeCount;
	
	public EvaluationDto(int eId, String userId, String eLectureName, String eProfessorName, int eLectureYear,
			String eSemesterDivide, String eLectureDivide, String eTitle, String eContent, String eTotalScore,
			String eCreditScore, String eComfortableScore, String eLectureScore, int eLikeCount) {
		super();
		this.eId = eId;
		this.userId = userId;
		this.eLectureName = eLectureName;
		this.eProfessorName = eProfessorName;
		this.eLectureYear = eLectureYear;
		this.eSemesterDivide = eSemesterDivide;
		this.eLectureDivide = eLectureDivide;
		this.eTitle = eTitle;
		this.eContent = eContent;
		this.eTotalScore = eTotalScore;
		this.eCreditScore = eCreditScore;
		this.eComfortableScore = eComfortableScore;
		this.eLectureScore = eLectureScore;
		this.eLikeCount = eLikeCount;
	}

	public int geteId() {
		return eId;
	}

	public void seteId(int eId) {
		this.eId = eId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String geteLectureName() {
		return eLectureName;
	}

	public void seteLectureName(String eLectureName) {
		this.eLectureName = eLectureName;
	}

	public String geteProfessorName() {
		return eProfessorName;
	}

	public void seteProfessorName(String eProfessorName) {
		this.eProfessorName = eProfessorName;
	}

	public int geteLectureYear() {
		return eLectureYear;
	}

	public void seteLectureYear(int eLectureYear) {
		this.eLectureYear = eLectureYear;
	}

	public String geteSemesterDivide() {
		return eSemesterDivide;
	}

	public void seteSemesterDivide(String eSemesterDivide) {
		this.eSemesterDivide = eSemesterDivide;
	}

	public String geteLectureDivide() {
		return eLectureDivide;
	}

	public void seteLectureDivide(String eLectureDivide) {
		this.eLectureDivide = eLectureDivide;
	}

	public String geteTitle() {
		return eTitle;
	}

	public void seteTitle(String eTitle) {
		this.eTitle = eTitle;
	}

	public String geteContent() {
		return eContent;
	}

	public void seteContent(String eContent) {
		this.eContent = eContent;
	}

	public String geteTotalScore() {
		return eTotalScore;
	}

	public void seteTotalScore(String eTotalScore) {
		this.eTotalScore = eTotalScore;
	}

	public String geteCreditScore() {
		return eCreditScore;
	}

	public void seteCreditScore(String eCreditScore) {
		this.eCreditScore = eCreditScore;
	}

	public String geteComfortableScore() {
		return eComfortableScore;
	}

	public void seteComfortableScore(String eComfortableScore) {
		this.eComfortableScore = eComfortableScore;
	}

	public String geteLectureScore() {
		return eLectureScore;
	}

	public void seteLectureScore(String eLectureScore) {
		this.eLectureScore = eLectureScore;
	}

	public int geteLikeCount() {
		return eLikeCount;
	}

	public void seteLikeCount(int eLikeCount) {
		this.eLikeCount = eLikeCount;
	}
	
}
