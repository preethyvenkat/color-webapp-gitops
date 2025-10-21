from flask import Flask
import os

app = Flask(__name__)
color = os.getenv("COLOR", "#28A745")

@app.route("/")
def home():
    return f"""
    <html>
      <body style='background-color: {color};'>
        <h1>Green app deployed by Argo Rollouts, Hello from GitOps!</h1>
      </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8081)
