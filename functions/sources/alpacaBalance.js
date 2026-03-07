//We will also tell config that this Alpaca balance also comes with API keys
if(secrets.alpacaKey == "" || secrets.alpacaSecret == ""){
    throw Error("Need Alpaca keys!!")
}

//upload this to DON (but no secrets are stored in chain)
const alpacaRequest = Functions.makeHttpRequest({
    url: "https://paper-api.alpaca.markets/v2/account",
    headers: {
        "APCA-API-KEY-ID": secrets.alpacaKey,
        "APCA-API-SECRET-KEY": secrets.alpacaSecret
    }
})

const [response] = await Promise.all([alpacaRequest])

const portfolioBalance = response.data.portfolio_value;
console.log(`Alpaca Portfolio Balance: $${portfolioBalance}`);


return Functions.encodeUint256(Math.round(portfolioBalance * 100));