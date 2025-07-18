from fastapi import APIRouter

info_route = APIRouter()

cyber_topics = {
    "firewall": "A firewall is a network security device that monitors and controls incoming and outgoing network traffic based on predetermined security rules.",
    "encryption": "Encryption is the process of converting information or data into a code to prevent unauthorized access.",
    "phishing": "Phishing is a type of cyber attack that uses disguised email as a weapon. The goal is to trick the email recipient into believing that the message is something they want or need, such as a request from their bank or a note from someone in their company.",
    "nmap": "Nmap (Network Mapper) is an open source tool for network exploration and security auditing. It is used to discover hosts and services on a computer network by sending packets and analyzing the responses.",
}

@info_route.get('/{topic}', response_model=str)
def get_topic_info(topic: str):
    return {"topic": topic, "description": cyber_topics.get(topic.lower(), "Topic not found. Please try another one.")}
