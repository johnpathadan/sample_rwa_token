require("dotenv").config({ path: "../../.env" });
const requestConfig = require("../configs/alpacaMintConfig.js")
const { simulateScript, decodeResult } = require("@chainlink/functions-toolkit")

//this is what we will use to test sending this request to
// check what will happen on the chainlink nodes

async function main() {
  const { responseBytesHexstring, errorString, } =
    await simulateScript(requestConfig)

  if (responseBytesHexstring) {
    console.log(
      `Response returned by script: ${decodeResult(
        responseBytesHexstring,
        requestConfig.expectedReturnType
      ).toString()}\n`
    )
  }
    if (errorString) {
        console.error(`Error returned by script: ${errorString}\n`)
    }
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})