---
name: md-typo-corrector
description: >
  Highlight and fix spelling and grammar mistakes in user-provided text.
  Use this skill whenever the user asks to proofread, spellcheck, find typos,
  correct grammar, or review writing for errors — even if they phrase it casually
  (e.g. "check this", "any mistakes?", "clean this up"). Do NOT rewrite or
  paraphrase content; only surface and fix errors.
---

# STEP 0: Determine Input Type

- If the user provided a **file path or filename**: read the file using the Read tool, then proceed with its contents. Remember the file path — corrections will be written back in place.
- If the user **pasted text inline**: use that text directly. There is no file to write back to.

# STEP 1: Spell & Grammar Check

Proofread user-provided text for spelling and grammar mistakes, then present the corrected text with only the corrected words bolded, followed by a table of changes.

## Core Rules

- **Do NOT alter content, meaning, or style.** Only fix clear spelling and grammar errors.
- **Do NOT reformat.** If the input is Markdown, preserve all Markdown syntax as-is (do not render it). If it's plain text, keep it plain text.
- **Minimal intervention.** Do not change punctuation, capitalisation, or phrasing unless it is unambiguously wrong.
- Flag uncertain cases (e.g. intentional stylistic choices, dialect spellings) as comments rather than corrections.

## Output Format

Present the corrected text with each corrected word wrapped in shown in ITALIC BOLD RED so only the changed words stand out in italic bold red while other text are just normal text (non-bold and terminal colored). Below the corrected text, list each correction in a table showing the original and corrected word.

Output will use formatting options like "<span style="color:red">xyzzy</span>" to indicate output formatting and color, please show them in the terminal directly with the styling choices applied. 

### Example

Input text:
> She recieved the the packege yesturday and was very suprised.

Output:

She <span style="color:red">***received***</span> <span style="color:red">***the***</span> package <span style="color:red">***yesterday***</span> and was very <span style="color:red">***surprised***</span>.

| Original | Corrected | Reason |
|----------|-----------|--------|
| recieved | received | Misspelling |
| the the | the | Duplicate word |
| packege | package | Misspelling |
| yesturday | yesterday | Misspelling |
| suprised | surprised | Misspelling |

## When There Are No Errors

If the text contains no spelling or grammar mistakes, say so clearly and do not produce a diff.

## Handling Ambiguous Cases

If something looks like a possible error but could be intentional (e.g. a brand name, a dialect word, or unconventional punctuation for stylistic effect), add a short note below the diff rather than changing it:

> ⚠️ **Note:** "colour" — kept as-is (British English spelling, likely intentional).

## Scope

- Fix: misspellings, wrong homophones (their/there/they're), subject-verb disagreement, duplicate words, missing or wrong articles (a/an).
- Do not touch: sentence restructuring, word choice improvements, tone, style, or anything that would change the author's voice.

# STEP 2: Offer to Apply Corrections

After presenting the corrections:

- If the input was **pasted inline**: skip this step — there is nothing to write back.
- If the input came from a **file**: ask the user how they'd like to proceed using the AskUserQuestion tool.

## 2a. Apply mode selection

Use the **AskUserQuestion tool** to present an interactive selection (the user navigates with arrow keys and confirms with Enter):

- Question: "How would you like to apply the corrections?"
- Options:
  - "Apply all" — applies every correction at once
  - "Review one by one" — step through each correction individually
  - "Cancel" — make no changes

## 2b. If "Apply all"

Apply every correction to the source file using the Edit tool, then confirm:
> "Done — X corrections applied."

## 2c. If "Review one by one"

For each correction, use the **AskUserQuestion tool** to ask:

- Question: `Correction X/Y: "original" → "corrected". Apply this fix?`
- Options:
  - "Apply" — apply this correction
  - "Skip" — leave this word unchanged

After all corrections are reviewed, apply the accepted ones and confirm:
> "Done — X of Y corrections applied."

## 2d. If "Cancel"

Say "No changes made." and stop.
