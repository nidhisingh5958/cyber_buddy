import traceback
from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
import os
from dotenv import load_dotenv
from app.utils import setup_logging

load_dotenv()
logger = setup_logging()

# Set default Groq API key and model from environment
GROQ_API_KEY = os.getenv("GROQ_API_KEY", "")
DEFAULT_MODEL = os.getenv("DEFAULT_MODEL", "llama-3.3-70b-versatile")

# Check if Groq API key is available
if not GROQ_API_KEY:
    logger.warning("No Groq API key found in environment variables. API will not function properly.")

def generate_response(input_prompt: str):
    try:
        # Validate input
        if not input_prompt or not input_prompt.strip():
            logger.error("Empty or invalid input prompt provided")
            return {
                "response": "Please provide a valid question or prompt.",
                "status": "error",
                "error_type": "invalid_input"
            }

        # Check if API key is available
        if not GROQ_API_KEY:
            logger.error("Groq API key not configured")
            return {
                "response": "API configuration error. Please contact the administrator.",
                "status": "error",
                "error_type": "configuration_error"
            }

        logger.info(f"Generating response for prompt: {input_prompt[:100]}...")
        
        llm = ChatGroq(
            groq_api_key=GROQ_API_KEY,
            model_name=DEFAULT_MODEL,
            temperature=0.7,
            max_tokens=2048
        )

        # Create the prompt template
        prompt = ChatPromptTemplate.from_messages([
            ("system", """
You are a Cybersecurity Educator — a knowledgeable, patient, and practical instructor. Your role is to help users learn and master various **cybersecurity tools, techniques, and concepts**. The user may ask about **any tool, framework, protocol, threat model, or real-world use case** related to cybersecurity, and you must respond in a way that is:

* **Accurate and up-to-date**
* **Beginner-friendly but scalable to advanced levels**
* **Clear, structured, and hands-on**, including code examples, CLI commands, or config snippets if needed
* **Tool-agnostic when needed**, but capable of explaining vendor-specific or open-source solutions like Wireshark, Nmap, Metasploit, Burp Suite, OSSEC, Splunk, Suricata, etc.

Always:
* Break down complex terms into simple language
* Provide analogies or examples where possible
* Guide the learner step-by-step through how the tool or concept works
* Mention security best practices and common mistakes to avoid
* Offer additional resources (e.g., official docs, courses, GitHub repos) for further study if applicable

Stay focused strictly on cybersecurity topics, tools, and techniques unless asked otherwise.
            """),
            ("user", "{user_input}")
        ])
            
        # Create and invoke the chain
        chain = prompt | llm | StrOutputParser()
        
        # Fix: Use the correct variable name that matches the prompt template
        response_text = chain.invoke({"user_input": input_prompt})
        
        if not response_text or not response_text.strip():
            logger.warning("Empty response generated from LLM")
            return {
                "response": "I apologize, but I couldn't generate a proper response. Please try rephrasing your question.",
                "status": "warning",
                "error_type": "empty_response"
            }
        
        logger.info("Response generated successfully.")
        return {
            "response": response_text.strip(),
            "status": "success"
        }
        
    except ImportError as e:
        logger.error(f"Import error - missing dependencies: {str(e)}")
        return {
            "response": "System configuration error. Required dependencies are missing.",
            "status": "error",
            "error_type": "dependency_error"
        }
    except Exception as e:
        # Log the full traceback for debugging
        traceback_err = traceback.format_exc()
        logger.error(f"Error generating response: {traceback_err}")
        
        # Return a user-friendly error message
        error_message = "I encountered an error while processing your request. Please try again."
        
        # Add more specific error messages for common issues
        if "api" in str(e).lower():
            error_message = "There was an issue connecting to the AI service. Please try again later."
        elif "timeout" in str(e).lower():
            error_message = "The request took too long to process. Please try again with a shorter question."
        elif "rate limit" in str(e).lower():
            error_message = "Too many requests. Please wait a moment before trying again."
        
        return {
            "response": error_message,
            "status": "error",
            "error_type": "processing_error",
            "technical_details": str(e) if logger.level <= 10 else None  # Include details only in debug mode
        }

# import traceback
# from langchain_groq import ChatGroq
# from langchain_core.prompts import ChatPromptTemplate
# from langchain_core.output_parsers import StrOutputParser
# import os
# from dotenv import load_dotenv
# from app.utils import setup_logging

# load_dotenv()
# logger = setup_logging()

# # Set default Groq API key and model from environment
# GROQ_API_KEY = os.getenv("GROQ_API_KEY", "")
# DEFAULT_MODEL = os.getenv("DEFAULT_MODEL", "llama-3.3-70b-versatile")


# # Check if Groq API key is available
# if not GROQ_API_KEY:
#     print("WARNING: No Groq API key found in environment variables. API will not function properly.")


# def generate_response(input_prompt: str):
#     try:
#         llm = ChatGroq(
#                 groq_api_key=GROQ_API_KEY,
#                 model_name=DEFAULT_MODEL
#             )

#         # Create the prompt template
#         prompt = ChatPromptTemplate.from_messages([
#         ("system",
#         """
#     You are a Cybersecurity Educator — a knowledgeable, patient, and practical instructor. Your role is to help users learn and master various **cybersecurity tools, techniques, and concepts**. The user may ask about **any tool, framework, protocol, threat model, or real-world use case** related to cybersecurity, and you must respond in a way that is:

#     * **Accurate and up-to-date**
#     * **Beginner-friendly but scalable to advanced levels**
#     * **Clear, structured, and hands-on**, including code examples, CLI commands, or config snippets if needed
#     * **Tool-agnostic when needed**, but capable of explaining vendor-specific or open-source solutions like Wireshark, Nmap, Metasploit, Burp Suite, OSSEC, Splunk, Suricata, etc.

#     Always:

#     * Break down complex terms into simple language
#     * Provide analogies or examples where possible
#     * Guide the learner step-by-step through how the tool or concept works
#     * Mention security best practices and common mistakes to avoid
#     * Offer additional resources (e.g., official docs, courses, GitHub repos) for further study if applicable

#     Stay focused strictly on cybersecurity topics, tools, and techniques unless asked otherwise.

#     """),
        
#         ("user", 
#         f"You are a Cybersecurity Educator. The user will ask about tools, techniques, and concepts in cybersecurity. "
#         f"Your job is to explain any cybersecurity topic — from basic to advanced — in a clear, practical, and hands-on manner.\n"
#         f"Use simple language, include real-world examples, commands, configurations, and best practices wherever needed.\n"
#         f"The user's query: {input_prompt}"),

#     ("assistant", 
#         "Provide an informative, technically accurate, and beginner-to-advanced friendly explanation based on the user's request. "
#         "Include practical details, examples, and further learning resources if applicable. Avoid fluff — focus on clarity, security relevance, and actionability.")
#         ])

            
#         # Create and invoke the chain
#         chain = prompt | llm | StrOutputParser()
#         summary = chain.invoke({"cyberbuddy": prompt})
#         logger.info("Generated response successfully.")
#         return {
#             "response": summary, "status": "success"}
#     except Exception as e:
#         traceback_err = traceback.format_exc()
#         logger.error(f"Error generating response: {traceback_err}")
#         return f"An error occurred while generating the response: {str(e)}"