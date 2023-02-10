# Linux disk scheduler

## Available disk schedulers

- `none / noop`: Implements a first-in first-out (FIFO) scheduling algorithm. It merges requests at the generic block layer through a simple last-hit cache.

- `mq-deadline`: Attempts to provide a guaranteed latency for requests from the point at which requests reach the scheduler.

The mq-deadline scheduler sorts queued I/O requests into a read or write batch and then schedules them for execution in increasing logical block addressing (LBA) order. By default, read batches take precedence over write batches, because applications are more likely to block on read I/O operations. After mq-deadline processes a batch, it checks how long write operations have been starved of processor time and schedules the next read or write batch as appropriate.

This scheduler is suitable for most use cases, but particularly those in which the write operations are mostly asynchronous.

- `bfq`: Targets desktop systems and interactive tasks.

The bfq scheduler ensures that a single application is never using all of the bandwidth. In effect, the storage device is always as responsive as if it was idle. In its default configuration, bfq focuses on delivering the lowest latency rather than achieving the maximum throughput.

bfq is based on cfq code. It does not grant the disk to each process for a fixed time slice but assigns a budget measured in number of sectors to the process.

This scheduler is suitable while copying large files and the system does not become unresponsive in this case.

- `kyber`: The scheduler tunes itself to achieve a latency goal by calculating the latencies of every I/O request submitted to the block I/O layer. You can configure the target latencies for read, in the case of cache-misses, and synchronous write requests.

This scheduler is suitable for fast devices, for example NVMe, SSD, or other low latency devices.

## Use case

- `mq-deadline or bfq` - Traditional HDD with a SCSI interface
- `none` - Use none, especially when running enterprise applications. Alternatively, use kyber. High-performance SSD or a CPU-bound system with fast storage
- `bfq` -  Desktop or interactive tasks
- `none` - Use mq-deadline. With a host bus adapter (HBA) driver that is multi-queue capable, use none. Virtual guest

## Check the active disk scheduler

```bash
cat /sys/block/device/queue/scheduler
# [mq-deadline] kyber bfq none
```

## Runtime set disk scheduler

```bash
echo "none" > /sys/block/sda/queue/scheduler
```

## Changing the Scheduler on Boot

```bash
vi /etc/default/grub

GRUB_CMDLINE_LINUX="elevator=noop"
# or
GRUB_CMDLINE_LINUX="elevator=noop"

update-grub2

# V2 Debian like system
# /etc/udev/rules.d/60-scheduler.rules

ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/scheduler}="none"

systemctl restart systemd-udev-trigger.service
```

## Reference links

- [Chapter 19. Setting the disk scheduler](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_storage_devices/setting-the-disk-scheduler_managing-storage-devices)
- [Improving Linux System Performance with I/O Scheduler Tuning](https://www.cloudbees.com/blog/linux-io-scheduler-tuning)
- [Verifying the Disk I/O Scheduler on Linux](https://docs.oracle.com/en/database/oracle/oracle-database/19/cwlin/setting-the-disk-io-scheduler-on-linux.html#GUID-B59FCEFB-20F9-4E64-8155-7A61B38D8CDF)
