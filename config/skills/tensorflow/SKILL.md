---
name: tensorflow
description: TensorFlow for production ML pipelines and deep learning
---

### Core Concepts
- **Keras API**: High-level `tf.keras.Sequential` and `Model` (Functional API) for model building
- **tf.data**: High-performance input pipeline with `Dataset.from_tensor_slices`, map, batch, prefetch
- **Eager Execution**: Imperative execution by default in TF2 with `tf.function` for graph compilation
- **SavedModel**: Universal serialization format for serving with `model.save("path")`
- **TF Serving**: gRPC/REST server for production model deployment with version management
- **TensorBoard**: Visualization toolkit via `tf.keras.callbacks.TensorBoard` logging

### Common Patterns
- `tf.keras.Sequential([layers.Dense(128, activation="relu"), layers.Dropout(0.2), layers.Dense(10, "softmax")])`
- `model.compile(optimizer="adam", loss="sparse_categorical_crossentropy", metrics=["accuracy"])`
- `model.fit(train_ds, validation_data=val_ds, epochs=10, callbacks=[early_stopping])`
- `tf.data.Dataset.from_tensor_slices((x, y)).batch(32).prefetch(tf.data.AUTOTUNE)`
- `@tf.function` decorator to trace and optimize Python functions into graphs
- Distribution strategy: `with MirroredStrategy().scope():` for multi-GPU training

### Best Practices
- Chain `.cache()`, `.shuffle()`, `.batch()`, `.prefetch()` for optimal input pipeline
- Use `tf.keras.mixed_precision.set_global_policy("mixed_float16")` for speedup
- Prefer `tf.keras.Model` subclassing for research, Functional API for production
- Validate SavedModel with `saved_model_cli show --dir exported/path`
- Set `TF_CPP_MIN_LOG_LEVEL=3` to suppress verbose INFO logs in production
