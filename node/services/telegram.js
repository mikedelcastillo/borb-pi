require("dotenv").config()

const axios = require('axios')

const {TELEGRAM_TOKEN, TELEGRAM_CHAT_ID} = process.env
const url = `https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage`

module.exports = {
    sendMessage: (text) => axios.get(url, {
        params: {
            chat_id: TELEGRAM_CHAT_ID,
            text,
        }
    }),
}