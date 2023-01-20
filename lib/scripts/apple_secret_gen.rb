require "jwt"

# This script is dumb bullshit apple makes us do to enable sign in with apple.
# See: https://supabase.com/docs/guides/auth/social-login/auth-apple

key_file = "/Users/caseycrogers/Documents/code/cast_me_app/keys/AuthKey_765VMDW582.p8"
team_id = "35UD35JB5L"
client_id = "signin.com.cast.me.app"
key_id = "765VMDW582"

validity_period = 180 # In days. Max 180 (6 months) according to Apple docs.

private_key = OpenSSL::PKey::EC.new IO.read key_file

token = JWT.encode(
	{
		iss: team_id,
		iat: Time.now.to_i,
		exp: Time.now.to_i + 86400 * validity_period,
		aud: "https://appleid.apple.com",
		sub: client_id
	},
	private_key,
	"ES256",
	header_fields=
	{
		kid: key_id
	}
)
puts token