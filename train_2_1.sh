DATASET=PMINDIA
VERSION=V22
CUDA_VISIBLE_DEVICES=0 fairseq-train \
    ./data-bin/$DATASET \
    --task translation \
    --source-lang en --target-lang ta \
    --batch-size 256 \
    --arch transformer \
    --encoder-layers 5 --decoder-layers 5 \
    --share-decoder-input-output-embed \
    --encoder-attention-heads 8 --decoder-attention-heads 8 \
    --encoder-embed-dim 512 --decoder-embed-dim 512 \
    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
    --lr 1e-4 --lr-scheduler inverse_sqrt --warmup-updates 4000 \
    --dropout 0.3 --weight-decay 0.0001 \
    --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
    --max-tokens 4096 \
    --tensorboard-logdir tensorboard_log/$VERSION-$DATASET \
    --tokenizer moses \
    --eval-bleu \
    --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
    --eval-bleu-detok moses \
    --eval-bleu-remove-bpe \
    --eval-bleu-print-samples \
    --best-checkpoint-metric bleu --maximize-best-checkpoint-metric \
    --save-dir checkpoints/$VERSION-$DATASET \
    --tensorboard-logdir ./tensorboard_log \
    --keep-last-epochs 1 \
    --log-format=json --log-interval=10 2>&1 | tee train.log &