#include "pomodoro_timer.h"

PomodoroTimer::PomodoroTimer(QObject* parent) : QObject(parent), effect(this) {
    connect(this, &PomodoroTimer::stateChanged, this, &PomodoroTimer::setTargetTime);

    effect.setSource(QUrl::fromLocalFile(":/sounds/notify002.wav"));
    effect.setVolume(0.4);
    timer_.setInterval(1000);
    connect(&timer_, &QTimer::timeout, this, &PomodoroTimer::onTimeout);
    state_ = WORK;
    reset();
}

int PomodoroTimer::currentTime() const {
    return remaining_seconds_;
}

bool PomodoroTimer::isRunning() const {
    return is_running_;
}

PomodoroTimer::TimerState PomodoroTimer::state() const {
    return state_;
}

void PomodoroTimer::start()
{
    if (!is_running_) {
        timer_.start();
        is_running_ = true;
        emit runningChanged();
    }
}

void PomodoroTimer::stop()
{
    if (is_running_) {
        timer_.stop();
        is_running_ = false;
        emit runningChanged();
    }
}

void PomodoroTimer::reset()
{
    stop();
    setTargetTime();
    emit timeChanged();
}

void PomodoroTimer::setTargetTime() {
    switch (state_) {
    case WORK:
        remaining_seconds_ = WORK_TIME;
        break;
    case BREAK:
        remaining_seconds_ = BREAK_TIME;
        break;
    default: break;
    }

    emit timeChanged();
}

void PomodoroTimer::onTimeout() {
    if (remaining_seconds_ > 0) {
        remaining_seconds_--;
        emit timeChanged();
    } else {
        if (state_ == WORK) {
            state_ = BREAK;
            emit stateChanged();
            emit finished();
        } else {
            stop();
            state_ = WORK;
            emit stateChanged();
            emit finished();
        }
    }

    if (state_ == BREAK && remaining_seconds_ == BREAK_TIME) {
        effect.play();
    }
}
