import React from "react";
import { render, screen } from "@testing-library/react";
import "@testing-library/jest-dom";
import App from "./App";

test("renders title", () => {
  render(<App />);
  const heading = screen.getByText(/Multi-Repo Demo Service/i);
  expect(heading).toBeInTheDocument();
});
