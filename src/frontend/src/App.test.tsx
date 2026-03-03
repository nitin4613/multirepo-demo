import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders title', () => {
  render(<App />);
  const heading = screen.getByText(/CarGurus Multi-Repo Service/i);
  expect(heading).toBeInTheDocument();
});
