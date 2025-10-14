from fastapi import FastAPI
app = FastAPI()

@app.get("/healthz")
def healthz():
    return {"ok": True, "service": "payments-python"}

@app.get("/")
def root():
    return {"message": "Hello from payments-python"}
