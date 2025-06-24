def analyze_log(log_data: str) -> str:
    if "unauthorized" in log_data.lower():
        return "The log indicates unauthorized access attempts."
    elif "error" in log_data.lower():
        return "The log contains error messages that may indicate system issues."
    elif "success" in log_data.lower():
        return "The log indicates successful operations."
    else:
        return "The log does not contain recognizable patterns. Further analysis may be required."
    