docker run -p 8000:8000 -p 5173:5173 \
  -v $(pwd)/data/hedge_fund.db:/app/app/backend/hedge_fund.db \
  --env-file .env \
  trading-ai
