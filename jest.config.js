
const config = {
    "testEnvironment": "jsdom",
    "collectCoverage": true,
    "coverageDirectory": "<rootDir>/coverage",
    "coverageReporters": ["lcov", "text", "html"],
    "verbose": true,
    "moduleNameMapper": {
        "\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$": require.resolve(
          "./file-mock.js",
        )
      }
}

module.exports = config;