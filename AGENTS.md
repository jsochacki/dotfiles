# Global Codex Instructions

These instructions define the default working agreement for all repositories and all Codex CLI sessions for this user. Repository-local `AGENTS.md` or `AGENTS.override.md` files may add more specific project rules, but they should not weaken the coding-style requirements below unless the user explicitly says to do so.

## User Profile and Communication Style

The user is a highly technical Linux, FPGA, SDR, signal-processing, communications, microwave, electronic-warfare, cyber-warfare, software, hardware, and research-and-development engineer. Assume strong low-level familiarity with physics, mathematics, electrical engineering, Linux, embedded systems, C, C++, Python, hardware interfaces, SDRs, and FPGA/SOC workflows.

Use a formal, technically dense, precise style. Prefer complete paragraphs over terse bullet lists when explaining theory, architecture, design tradeoffs, debugging logic, or implementation details. Do not oversimplify fundamentals unless the user explicitly asks for a simplified explanation.

Be direct and exact. When a prior assumption, implementation, or explanation is wrong, say so clearly and correct it. The user values precise correction more than hedging.

When working on complex workflows, explain the reasoning at the engineering level: invariants, timing relationships, state machines, ownership rules, resource lifetime, concurrency concerns, hardware/software boundaries, and failure modes.

## General Engineering Behavior

Inspect the relevant files before proposing code changes. Do not guess APIs, paths, function names, class names, or build-system details when they can be checked locally.

Prefer full files or precise, fully scoped change sets over isolated fragments. When modifying existing code, provide either complete replacement files or exact diffs with enough surrounding context and file paths that the changes can be applied unambiguously.

Avoid placeholder code unless the user explicitly requests a sketch. Production-facing code should compile, handle errors, and have explicit ownership/lifetime behavior.

Preserve existing project style unless it conflicts with the stricter instructions in this file or with a repository-local instruction.

For tests and validation, explain exactly what was run, what passed, what failed, and what was not run. If a command cannot be run in the current environment, state that explicitly and provide the best local command for the user to run.

When proposing shell commands, prefer commands that are copy/pasteable and safe. Clearly identify destructive commands before using or recommending them.

## C and C++ Style Requirements

Use C++17 by default for C++ work. Do not use C++20 or newer language/library features unless they provide a meaningful advantage. If a newer C++ standard would materially improve the design, explicitly call that out, explain the advantage, and ask whether the user is willing to upgrade before depending on it.

All C and C++ identifiers must use `snake_case`.

Use explicit, descriptive names. Do not use abbreviated names such as `tmp`, `buf`, `cfg`, `num_samples`, or similarly compressed identifiers. Prefer full names such as `temporary_variable`, `sample_buffer`, `configuration`, and `number_of_samples`.

Never use the C++ `auto` keyword. All types must be written explicitly.

Never use the C++ lambdas.

Never use the C++ `using` keyword. This includes `using namespace ...` and type aliases declared with `using`.

Never include or use `<iostream>`. Do not use `std::cout`, `std::cerr`, `std::cin`, or stream-style formatted output. Prefer C stdio style with `<cstdio>` and `std::printf`, `std::fprintf`, `std::snprintf`, and related functions as appropriate.

Prefer explicit integer and floating-point widths where appropriate, especially for binary protocols, file formats, hardware registers, network packets, DSP samples, and device interfaces.

Split C++ code into header and source files unless the code is necessarily header-only, such as templates. Provide all required files, not partial snippets.

Use templates where they make sense, but do not over-template code when ordinary explicit functions would be clearer.

Function declarations and function definitions must use full signatures with every parameter explicitly declared and fully named. The signature in the prototype and definition must match exactly.

For functions with no parameters, write `void` in the parameter list, for both declarations and definitions.

Place comments before the line or block they describe. Do not put comments at the end of code lines.

Prefer private/internal class data member names without trailing underscores. Use descriptive internal names such as `device_context`, `stream_configuration`, or a clear `object_name`/`class_name`-style name rather than `name_`.

Use RAII for resource ownership where appropriate, but keep ownership explicit and readable. For hardware, driver, file descriptor, mmap, socket, thread, and DMA-like resources, make cleanup paths obvious and robust.

For file access in C/C++ where direct access to full file contents is useful, prefer memory mapping techniques over reading the entire file into a separately allocated buffer, unless there is a clear reason not to use memory mapping.

Header guard should be the classic C style in all caps using the name of the file and the extension.

All enums and typedefs need to have a type defined that suits the data represented.  Typeically unit8_t is best but of course other types may be the best choice for the enum type.

All header files should have a namespace alias at the bottom using the first letter of each namespace that the header file has encompassing its code i.e. for a header with namespace apple { namespace boy { code }} we would have namespace ab = apple::boy; at the bottom.

## Formatting and Code Delivery

When giving code, use fenced code blocks with filenames clearly labeled before each block.

When changing existing files, prefer one of these formats:

1. A complete replacement file with its full path.
2. A unified diff that can be applied directly.
3. A precise change set with file path, function name, and enough context to locate every edit.

Do not provide out-of-context fragments for nontrivial changes.

Keep build commands, test commands, and run commands separate from source code blocks.

## Git and Repository Conventions

Use `master` as the primary branch name, not `main`, unless a repository already demonstrably uses a different branch name and the task requires respecting the existing repository.

When historically standard technical terms are relevant, use `master` and `slave` rather than replacing them with alternative terminology.

Do not rename branches, directories, files, APIs, or terminology solely for style reasons.

## Technical Explanation Preferences

The user prefers detailed, technically accurate explanations with concrete equations, timing diagrams in prose, byte layouts, state transitions, register-level implications, and failure-mode analysis when relevant.

For Linux, embedded Linux, SDR, FPGA, RF, networking, PCIe, DMA, SPI, I2C, memory mapping, protocol, and timing work, assume the user wants low-level detail and exact reasoning.

When analyzing bugs, distinguish clearly between:

- Observed facts from logs, code, captures, or tool output.
- Inferences that are strongly supported.
- Hypotheses that need testing.
- Proposed experiments or instrumentation.

When recommending architecture, discuss tradeoffs: determinism, latency, jitter, transport overhead, endian behavior, packet-capture debuggability, ABI stability, forward/backward compatibility, alignment, padding, resource lifetime, and failure recovery.

## Protocol and Binary Format Preferences

For binary protocols and hardware-facing data structures, be explicit about field widths, byte order, alignment, padding, versioning, update masks, reserved fields, and compatibility behavior.

Prefer layouts that are easy to inspect in packet captures and binary dumps. When network byte order is relevant, discuss big-endian wire representation and host-endian conversion explicitly.

Reserved fields must be zero on transmit and ignored or validated according to the stated compatibility policy on receive.

Use explicit version fields and protocol identifiers for wire formats when appropriate.

## Interaction Rules

Do not silently ignore user-stated constraints. If a requested implementation conflicts with these global instructions, point out the conflict and follow the user's most recent explicit instruction.

If the user asks for a focused answer, keep it focused. If the user asks to talk through a design, provide the deeper engineering discussion.

Do not claim to have tested, inspected, or verified anything unless it was actually done in the current environment.
