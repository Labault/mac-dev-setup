const { gitmojiCodeRegex, gitmojiUnicodeRegex } = require('@gitmoji/gitmoji-regex');

module.exports = {
  extends: ['@commitlint/config-conventional', 'gitmoji'],
  parserPreset: {
    parserOpts: {
      headerPattern: new RegExp(
        `^\\s*(?:${gitmojiCodeRegex.source}|${gitmojiUnicodeRegex.source})\\s(?<type>\\w*)(?:\\((?<scope>.*)\\))?!?:\\s(?<subject>.+)$`,
      ),
      headerCorrespondence: ['type', 'scope', 'subject'],
    },
  },
};
