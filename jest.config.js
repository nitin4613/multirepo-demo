module.exports = {
  testEnvironment: 'jest-environment-jsdom',
  transform: {
    '^.+\\.tsx?$': 'ts-jest'
  },
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json'],
  roots: ['<rootDir>/src/frontend/src'],
  collectCoverageFrom: [
    'src/frontend/src/**/*.{ts,tsx}',
    '!src/frontend/src/**/*.d.ts',
    '!src/e2e/**/*'
  ],
  coverageReporters: ['text', 'lcov', 'json']
};
