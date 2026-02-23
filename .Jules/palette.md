## 2025-02-23 - Loading State for Async Actions
**Learning:** Users need immediate feedback when performing data-heavy operations like saving a capture session, which involves media processing and AI analysis. Without it, they may perceive the app as unresponsive or trigger the action multiple times.
**Action:** Always wrap async actions (especially those involving I/O or AI) with a visible loading state (e.g., `ProgressView`) and disable the trigger button to prevent re-submission. Use `defer` in ViewModels to ensure state reset.
