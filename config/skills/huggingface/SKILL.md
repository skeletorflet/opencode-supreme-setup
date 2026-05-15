---
name: huggingface
description: HuggingFace ecosystem for transformers, datasets, and model deployment
---

### Core Concepts
- **Transformers Pipeline**: `pipeline("text-classification")` abstracts tokenize-infer-decode
- **Model Hub**: 500k+ pretrained models hosted at huggingface.co/models
- **Fine-tuning**: `Trainer` API with `TrainingArguments` for supervised fine-tuning
- **Datasets Library**: `load_dataset("dataset_name")` with streaming, sharding, mapping
- **Tokenizers**: Fast tokenizers (Rust-backed) with `encode`/`decode`/`batch_encode`
- **Inference API**: Serverless or dedicated endpoints via `huggingface_hub.InferenceClient`

### Common Patterns
- `pipeline("text-generation", model="mistralai/Mistral-7B-v0.1")` for inference
- `AutoModelForSequenceClassification.from_pretrained("model")` with `Trainer` for fine-tuning
- `load_dataset("imdb", split="train").select(range(100))` for dataset slicing
- `AutoTokenizer.from_pretrained("model")` with `padding=True, truncation=True`
- Push to hub: `model.push_to_hub("my-finetuned-model", use_auth_token=True)`
- Spaces: `gradio.Interface(fn, inputs, outputs).launch()` deployed via HF Spaces

### Best Practices
- Use `safetensors` format for faster and safer model loading
- Enable `device_map="auto"` for multi-GPU inference
- Set `load_in_4bit=True` with BitsAndBytesConfig for memory-efficient fine-tuning
- Pin `transformers` version in production to avoid breaking API changes
- Cache models in persistent volume to avoid repeated downloads
