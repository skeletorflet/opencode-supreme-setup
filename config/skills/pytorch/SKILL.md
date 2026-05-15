---
name: pytorch
description: PyTorch for deep learning research and production
---

### Core Concepts
- **Tensors**: Multi-dimensional arrays on CPU/GPU with autograd tracking
- **Autograd**: Automatic differentiation via `requires_grad` and `backward()`
- **nn.Module**: Base class for neural network layers with `forward()` method
- **Optimizers**: `torch.optim.SGD`, `Adam`, `AdamW` with `zero_grad()`/`step()` loop
- **DataLoader**: Batched, shuffled, parallel data loading with `Dataset` subclass
- **Distributed Training**: `DistributedDataParallel` for multi-GPU with NCCL backend

### Common Patterns
- `nn.Sequential(nn.Linear(d_in, d_hid), nn.ReLU(), nn.Linear(d_hid, d_out))` for simple nets
- Training loop: `for x, y in dataloader: pred = model(x); loss = loss_fn(pred, y); loss.backward(); optimizer.step(); optimizer.zero_grad()`
- `torch.utils.data.Dataset` with `__len__` and `__getitem__` for custom data
- Transfer learning: freeze `requires_grad=False` on backbone, train new head
- `torch.compile(model)` for graph optimization with `mode="reduce-overhead"`
- `model.to("cuda")` and `x.to("cuda")` for GPU execution

### Best Practices
- Use `with torch.no_grad():` for inference to disable gradient computation
- Set `torch.manual_seed(42)` and `torch.cuda.manual_seed_all(42)` for reproducibility
- Profile with `torch.profiler` before optimizing GPU utilization
- Use `pin_memory=True` in DataLoader for faster CPU-to-GPU transfer
- Enable `grad_scaler` for mixed precision training with `torch.cuda.amp`
