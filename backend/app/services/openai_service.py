import openai

openai.api_key = "openai_api_key"

def generate_response(prompt: str):
    response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a cybersecurity expert."},
                {"role": "user", "content": prompt}
            ]
        )
    return response.choices[0].message.content.strip()