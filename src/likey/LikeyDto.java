package likey;

public class LikeyDto {

	String userId;
	int eId;
	String ip;
	
	public LikeyDto(String userId, int eId, String ip) {
		super();
		this.userId = userId;
		this.eId = eId;
		this.ip = ip;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int geteId() {
		return eId;
	}

	public void seteId(int eId) {
		this.eId = eId;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}
	
}
