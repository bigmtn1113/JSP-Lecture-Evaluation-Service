package user;

public class UserDto {

	private String id;
	private String pw;
	private String email;
	private String emailHash;
	private char emailChecked;
	
	public UserDto(String id, String pw, String email, String emailHash, char emailChecked) {
		super();
		this.id = id;
		this.pw = pw;
		this.email = email;
		this.emailHash = emailHash;
		this.emailChecked = emailChecked;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getEmailHash() {
		return emailHash;
	}

	public void setEmailHash(String emailHash) {
		this.emailHash = emailHash;
	}

	public char isEmailChecked() {
		return emailChecked;
	}

	public void setEmailChecked(char emailChecked) {
		this.emailChecked = emailChecked;
	}
	
}
