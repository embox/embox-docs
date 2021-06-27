
# Quick Overview
Embox is a real-time operating system for embedded systems.

Embox is a cross-platform operating system. All arch-dependent code is organized as separate modules. It makes porting process to a new platform easy. Currently, Embox supports following architectures: ***ARM, x86, RISC_V, SPARC, Microblaze, MIPS, PPC, E2k***.

Embox is a multitasking operating system and supports different priority levels, preemptive and cooperative multitasking, priority inheritance and different synchronization primitives.

Embox provides POSIX-compatible layer, which allows to use a lot of existing Linux software. For example, Qt embedded, SSH server — Dropbear, PJSIP.

Embox development process is usual and pretty common for all platforms including resources restricted platforms such as MCUs because of using standard toolset.

Embox has low resources requirements because it is designed as a modular and configurable project. During the configuration stage, one can choose which modules will be included in the final image.

Embox allows to create secure systems. Statically building ensures that functionalities weren’t included in the target image couldn’t be executed.

Embox is suitable for Internet Of Things (IoT). It has well TCP/IP stack, a rich set of user software, but at the same time, it has low resources requirements.

Embox is suitable for robots. It allows to combine in one system tasks with rich functionalities and real-time tasks. You can create your own POSIX compatible application to control servos, motors, sensors etc., communicating with your robot through a network at the same time.

